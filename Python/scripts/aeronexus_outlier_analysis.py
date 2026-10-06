import os
import mysql.connector
import numpy as np
import pandas as pd

# Create the output folder
os.makedirs("outputs", exist_ok=True)

# Connect to the AeroNexus database
connection = mysql.connector.connect(
    host="localhost",
    user="root",
    password="Raghu@5678",
    database="aeronexus"
)

print("Connected to AeroNexus MySQL database successfully!")

try:
    # Load data without modifying the database
    flight_df = pd.read_sql(
        "SELECT * FROM flight_operations",
        connection
    )

    satisfaction_df = pd.read_sql(
        "SELECT * FROM passenger_satisfaction",
        connection
    )

    # --------------------------------------------------
    # 1. OUTLIER ANALYSIS USING IQR AND Z-SCORE
    # --------------------------------------------------

    outlier_results = []
    potential_outliers = []

    flight_columns = [
        "Dep_Delay_Min",
        "Arr_Delay_Min",
        "Taxi_Out_Min",
        "Taxi_In_Min",
        "Actual_Elapsed_Time_Min",
        "Distance_Miles"
    ]

    satisfaction_columns = ["Ticket_Price"]

    datasets = [
        ("Flight Operations", flight_df, flight_columns),
        ("Passenger Satisfaction", satisfaction_df, satisfaction_columns)
    ]

    for dataset_name, df, columns in datasets:
        for column in columns:
            values = pd.to_numeric(df[column], errors="coerce").dropna()

            if values.empty:
                continue

            # IQR method
            q1 = values.quantile(0.25)
            q3 = values.quantile(0.75)
            iqr = q3 - q1

            lower_bound = q1 - 1.5 * iqr
            upper_bound = q3 + 1.5 * iqr

            iqr_mask = (
                (pd.to_numeric(df[column], errors="coerce") < lower_bound)
                | (pd.to_numeric(df[column], errors="coerce") > upper_bound)
            ).fillna(False)

            # Z-score method
            std_dev = values.std()

            if std_dev == 0 or pd.isna(std_dev):
                z_mask = pd.Series(False, index=df.index)
            else:
                z_scores = (
                    pd.to_numeric(df[column], errors="coerce") - values.mean()
                ) / std_dev

                z_mask = (z_scores.abs() > 3).fillna(False)

            outlier_results.append({
                "Dataset": dataset_name,
                "Variable": column,
                "Q1": q1,
                "Q3": q3,
                "IQR": iqr,
                "IQR_Lower_Bound": lower_bound,
                "IQR_Upper_Bound": upper_bound,
                "IQR_Outlier_Count": int(iqr_mask.sum()),
                "IQR_Outlier_Percentage": round(
                    iqr_mask.sum() / len(df) * 100, 2
                ),
                "Z_Score_Outlier_Count": int(z_mask.sum())
            })

            # Save records flagged by either method
            flagged_mask = iqr_mask | z_mask

            if flagged_mask.any():
                flagged = df.loc[flagged_mask].copy()
                flagged.insert(0, "Dataset", dataset_name)
                flagged["Outlier_Variable"] = column
                flagged["IQR_Flag"] = iqr_mask.loc[flagged.index].values
                flagged["Z_Score_Flag"] = z_mask.loc[flagged.index].values
                potential_outliers.append(flagged)

    outlier_summary = pd.DataFrame(outlier_results)

    outlier_summary.to_csv(
        "outputs/outlier_analysis_summary.csv",
        index=False
    )

    print("\nOUTLIER ANALYSIS SUMMARY")
    print(outlier_summary.to_string(index=False))

    if potential_outliers:
        potential_outlier_df = pd.concat(
            potential_outliers,
            ignore_index=True
        )

        potential_outlier_df.to_csv(
            "outputs/potential_outlier_records.csv",
            index=False
        )

    print("\nPotential outlier records saved.")

    # --------------------------------------------------
    # 2. OPERATIONAL DATA-QUALITY CHECKS
    # --------------------------------------------------

    anomaly_results = []

    def add_check(check_name, mask, explanation):
        mask = pd.Series(mask, index=flight_df.index).fillna(False)

        anomaly_results.append({
            "Check": check_name,
            "Flagged_Count": int(mask.sum()),
            "Explanation": explanation
        })

    # Negative distance
    add_check(
        "Negative distance",
        flight_df["Distance_Miles"] < 0,
        "Distance should not be negative."
    )

    # Negative taxi-out time
    add_check(
        "Negative taxi-out time",
        flight_df["Taxi_Out_Min"] < 0,
        "Taxi-out duration should not be negative."
    )

    # Negative taxi-in time
    add_check(
        "Negative taxi-in time",
        flight_df["Taxi_In_Min"] < 0,
        "Taxi-in duration should not be negative."
    )

    # Invalid cancellation flag
    add_check(
        "Invalid cancellation flag",
        ~flight_df["Is_Cancelled"].isin([0, 1]),
        "Cancellation flag should be 0 or 1."
    )

    # Invalid diversion flag
    add_check(
        "Invalid diversion flag",
        ~flight_df["Is_Diverted"].isin([0, 1]),
        "Diversion flag should be 0 or 1."
    )

    # Both cancelled and diverted
    add_check(
        "Both cancelled and diverted",
        (flight_df["Is_Cancelled"] == 1)
        & (flight_df["Is_Diverted"] == 1),
        "Review flights marked both cancelled and diverted."
    )

    # --------------------------------------------------
    # FIXED CANCELLATION-CODE CHECK
    # Treat N/A and similar placeholders as missing-like.
    # --------------------------------------------------

    cancel_code_clean = (
        flight_df["Cancel_Code"]
        .fillna("")
        .astype(str)
        .str.strip()
        .str.upper()
    )

    has_real_cancel_code = ~cancel_code_clean.isin(
        ["", "N/A", "NA", "NONE", "NULL", "NAN"]
    )

    add_check(
        "Cancellation code on non-cancelled flight",
        (flight_df["Is_Cancelled"] == 0) & has_real_cancel_code,
        "Review non-cancelled flights containing an actual cancellation code."
    )

    # Cancelled flight without a real cancellation code
    add_check(
        "Cancelled flight without cancellation code",
        (flight_df["Is_Cancelled"] == 1) & ~has_real_cancel_code,
        "Review cancelled flights without a real cancellation code."
    )

    # Rating range checks
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

    for column in rating_columns:
        if column in satisfaction_df.columns:
            invalid_rating_mask = (
                (satisfaction_df[column] < 0)
                | (satisfaction_df[column] > 5)
            )

            anomaly_results.append({
                "Check": f"Invalid rating: {column}",
                "Flagged_Count": int(invalid_rating_mask.sum()),
                "Explanation": "Expected rating range is 0 to 5."
            })

    # Negative ticket price
    anomaly_results.append({
        "Check": "Negative ticket price",
        "Flagged_Count": int(
            (satisfaction_df["Ticket_Price"] < 0).sum()
        ),
        "Explanation": "Ticket price should not be negative."
    })

    # Save operational checks
    anomaly_df = pd.DataFrame(anomaly_results)

    anomaly_df.to_csv(
        "outputs/operational_anomaly_checks.csv",
        index=False
    )

    print("\nOPERATIONAL DATA-QUALITY CHECKS")
    print(anomaly_df.to_string(index=False))

    print("\nOutlier and anomaly analysis completed.")
    print("Check the outputs folder for the CSV results.")

finally:
    connection.close()
    print("\nMySQL connection closed.")

