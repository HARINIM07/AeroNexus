
import os
import mysql.connector
import numpy as np
import pandas as pd
from scipy.stats import chi2_contingency, spearmanr

os.makedirs("outputs", exist_ok=True)

connection = mysql.connector.connect(
    host="localhost",
    user="root",
    password="Raghu@5678",
    database="aeronexus"
)

print("Connected to AeroNexus MySQL database successfully!")

try:
    # --------------------------------------------------
    # 1. LOAD LINKED DATA
    # --------------------------------------------------

    query = """
    SELECT
        ps.Satisfaction_ID,
        ps.Flight_ID,
        ps.Passenger_ID,
        ps.Ticket_Price,
        ps.Class,
        ps.Travel_Type,
        ps.Actual_Satisfaction,

        ps.Inflight_Wifi_Service,
        ps.Departure_Arrival_Time_Convenience,
        ps.Ease_of_Online_Booking,
        ps.Gate_Location,
        ps.Food_and_Drink,
        ps.Online_Boarding,
        ps.Seat_Comfort,
        ps.Inflight_Entertainment,
        ps.On_Board_Service,
        ps.Leg_Room_Service,
        ps.Baggage_Handling,
        ps.Checkin_Service,
        ps.Inflight_Service,
        ps.Cleanliness,

        p.Age,
        p.Gender,
        p.Passenger_Type,

        fo.Dep_Delay_Min,
        fo.Arr_Delay_Min,
        fo.Is_Cancelled,
        fo.Is_Diverted,

        al.Airline_Name,
        origin.IATA_Code AS Origin_IATA,
        destination.IATA_Code AS Dest_IATA

    FROM passenger_satisfaction ps

    LEFT JOIN passenger p
        ON ps.Passenger_ID = p.Passenger_ID

    LEFT JOIN flight_operations fo
        ON ps.Flight_ID = fo.Flight_ID

    LEFT JOIN airline al
        ON fo.Airline_ID = al.Airline_ID

    LEFT JOIN airport origin
        ON fo.Origin_Airport_ID = origin.Airport_ID

    LEFT JOIN airport destination
        ON fo.Dest_Airport_ID = destination.Airport_ID
    """

    df = pd.read_sql(query, connection)

    print("\nLINKED ANALYSIS DATA")
    print("Rows and columns:", df.shape)
    print("\nSatisfaction categories:")
    print(df["Actual_Satisfaction"].value_counts(dropna=False))

    # A numeric order for the three satisfaction categories.
    # This is an ordinal score, not a measured satisfaction scale.
    satisfaction_map = {
        "Dissatisfied": 1,
        "Neutral": 2,
        "Satisfied": 3
    }

    df["Satisfaction_Score"] = (
        df["Actual_Satisfaction"]
        .astype("string")
        .str.strip()
        .str.title()
        .map(satisfaction_map)
    )

    # Create route and useful analysis groups
    df["Route"] = (
        df["Origin_IATA"].fillna("Unknown").astype(str)
        + "-"
        + df["Dest_IATA"].fillna("Unknown").astype(str)
    )

    df["Age_Group"] = pd.cut(
        df["Age"],
        bins=[0, 18, 30, 45, 60, 120],
        labels=[
            "Under 18",
            "18-30",
            "31-45",
            "46-60",
            "Over 60"
        ],
        include_lowest=True
    )

    df["Arrival_Delay_Group"] = pd.cut(
        df["Arr_Delay_Min"],
        bins=[-np.inf, 0, 15, 60, np.inf],
        labels=[
            "Early or on time",
            "1-15 min late",
            "16-60 min late",
            "Over 60 min late"
        ]
    )

    # --------------------------------------------------
    # 2. NUMERIC CORRELATION: SPEARMAN
    # --------------------------------------------------

    numeric_variables = [
        "Age",
        "Ticket_Price",
        "Dep_Delay_Min",
        "Arr_Delay_Min",
        "Is_Cancelled",
        "Is_Diverted"
    ]

    rating_columns = [
        "Inflight_Wifi_Service",
        "Departure_Arrival_Time_Convenience",
        "Ease_of_Online_Booking",
        "Gate_Location",
        "Food_and_Drink",
        "Online_Boarding",
        "Seat_Comfort",
        "Inflight_Entertainment",
        "On_Board_Service",
        "Leg_Room_Service",
        "Baggage_Handling",
        "Checkin_Service",
        "Inflight_Service",
        "Cleanliness"
    ]

    numeric_variables += rating_columns

    correlation_results = []

    for column in numeric_variables:
        pair = df[[column, "Satisfaction_Score"]].copy()

        pair[column] = pd.to_numeric(
            pair[column], errors="coerce"
        )

        pair = pair.dropna()

        if len(pair) < 3 or pair[column].nunique() < 2:
            continue

        rho, p_value = spearmanr(
            pair[column],
            pair["Satisfaction_Score"]
        )

        correlation_results.append({
            "Variable": column,
            "Sample_Size": len(pair),
            "Spearman_Rho": rho,
            "P_Value": p_value
        })

    correlation_df = pd.DataFrame(correlation_results)

    if not correlation_df.empty:
        correlation_df["Absolute_Rho"] = (
            correlation_df["Spearman_Rho"].abs()
        )

        correlation_df = correlation_df.sort_values(
            "Absolute_Rho", ascending=False
        )

    print("\nSPEARMAN CORRELATION RESULTS")
    print(correlation_df.to_string(index=False))

    correlation_df.to_csv(
        "outputs/spearman_correlation_results.csv",
        index=False
    )

    # --------------------------------------------------
    # 3. CATEGORICAL FACTORS: CHI-SQUARE + CRAMER'S V
    # --------------------------------------------------

    categorical_factors = [
        "Airline_Name",
        "Origin_IATA",
        "Dest_IATA",
        "Route",
        "Gender",
        "Passenger_Type",
        "Class",
        "Travel_Type",
        "Age_Group",
        "Arrival_Delay_Group",
        "Is_Cancelled",
        "Is_Diverted"
    ]

    chi_square_results = []

    for factor in categorical_factors:
        test_data = df[
            [factor, "Actual_Satisfaction"]
        ].dropna().copy()

        if test_data.empty:
            continue

        test_data[factor] = test_data[factor].astype(str)
        test_data["Actual_Satisfaction"] = (
            test_data["Actual_Satisfaction"]
            .astype(str)
            .str.strip()
            .str.title()
        )

        # Save counts and percentages for each factor
        counts = pd.crosstab(
            test_data[factor],
            test_data["Actual_Satisfaction"]
        )

        percentages = pd.crosstab(
            test_data[factor],
            test_data["Actual_Satisfaction"],
            normalize="index"
        ).mul(100).round(2)

        counts.to_csv(
            f"outputs/satisfaction_counts_{factor}.csv"
        )

        percentages.to_csv(
            f"outputs/satisfaction_percentages_{factor}.csv"
        )

        # Need at least two factor groups and two
        # satisfaction categories for the chi-square test.
        if counts.shape[0] < 2 or counts.shape[1] < 2:
            continue

        chi2, p_value, dof, expected = chi2_contingency(counts)

        n = counts.to_numpy().sum()
        rows, columns = counts.shape
        denominator = n * min(rows - 1, columns - 1)

        cramers_v = (
            np.sqrt(chi2 / denominator)
            if denominator > 0
            else np.nan
        )

        chi_square_results.append({
            "Factor": factor,
            "Sample_Size": int(n),
            "Number_of_Groups": rows,
            "Chi_Square": chi2,
            "Degrees_of_Freedom": dof,
            "P_Value": p_value,
            "Cramers_V": cramers_v,
            "Minimum_Expected_Count": expected.min()
        })

    chi_square_df = pd.DataFrame(chi_square_results)

    if not chi_square_df.empty:
        chi_square_df = chi_square_df.sort_values(
            "Cramers_V", ascending=False
        )

    print("\nCHI-SQUARE AND CRAMER'S V RESULTS")
    print(chi_square_df.to_string(index=False))

    chi_square_df.to_csv(
        "outputs/categorical_satisfaction_tests.csv",
        index=False
    )

    # --------------------------------------------------
    # 4. SATISFACTION BY ARRIVAL DELAY GROUP
    # --------------------------------------------------

    delay_summary = (
        df.dropna(subset=["Arrival_Delay_Group"])
        .groupby(
            "Arrival_Delay_Group",
            observed=False
        )["Satisfaction_Score"]
        .agg(["count", "mean", "median"])
        .reset_index()
    )

    delay_summary["Mean_Satisfaction_Score"] = (
        delay_summary["mean"].round(3)
    )

    delay_summary = delay_summary.drop(
        columns=["mean"]
    )

    print("\nSATISFACTION BY ARRIVAL DELAY GROUP")
    print(delay_summary.to_string(index=False))

    delay_summary.to_csv(
        "outputs/satisfaction_by_arrival_delay.csv",
        index=False
    )

    # --------------------------------------------------
    # 5. SATISFACTION COUNTS BY CATEGORY
    # --------------------------------------------------

    satisfaction_counts = (
        df["Actual_Satisfaction"]
        .value_counts(dropna=False)
        .rename_axis("Satisfaction_Category")
        .reset_index(name="Count")
    )

    satisfaction_counts["Percentage"] = (
        satisfaction_counts["Count"]
        / len(df) * 100
    ).round(2)

    satisfaction_counts.to_csv(
        "outputs/final_satisfaction_distribution.csv",
        index=False
    )

    print("\nSTATISTICAL ANALYSIS COMPLETED.")
    print("Results saved in the outputs folder.")

    print(
        "\nInterpretation note: service ratings are used to "
        "derive Actual_Satisfaction, so their relationships "
        "with that label are partly built into its definition."
    )

finally:
    connection.close()
    print("\nMySQL connection closed.")