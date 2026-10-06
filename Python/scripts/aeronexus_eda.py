import os
import mysql.connector
import pandas as pd

# Create output folder
os.makedirs("outputs", exist_ok=True)

# Connect to MySQL
connection = mysql.connector.connect(
    host="localhost",
    user="root",
    password="Raghu@5678",
    database="aeronexus"
)

print("Connected to AeroNexus MySQL database successfully!")

try:
    # Load flight operations
    flight_df = pd.read_sql(
        "SELECT * FROM flight_operations",
        connection
    )

    # Load passenger satisfaction
    satisfaction_df = pd.read_sql(
        "SELECT * FROM passenger_satisfaction",
        connection
    )

    # 1. Dataset overview
    for name, df in [
        ("Flight Operations", flight_df),
        ("Passenger Satisfaction", satisfaction_df)
    ]:
        print(f"\n{'=' * 60}")
        print(f"{name.upper()} - DATASET OVERVIEW")
        print("=" * 60)

        print("Rows and columns:", df.shape)
        print("\nColumn names:")
        print(df.columns.tolist())

        print("\nData types:")
        print(df.dtypes)

        print("\nMissing values:")
        print(df.isnull().sum()[df.isnull().sum() > 0])

        print("\nDuplicate complete rows:", df.duplicated().sum())

        print("\nDescriptive statistics:")
        print(df.describe(include="all").to_string())

    # 2. Flight operations key variables
    flight_columns = [
        "Dep_Delay_Min",
        "Arr_Delay_Min",
        "Taxi_Out_Min",
        "Taxi_In_Min",
        "Actual_Elapsed_Time_Min",
        "Distance_Miles",
        "Is_Cancelled",
        "Is_Diverted"
    ]

    print("\nFLIGHT OPERATIONS - KEY VARIABLES")
    print(flight_df[flight_columns].describe().to_string())

    # 3. Cancellation and diversion rates
    print("\nCANCELLATION AND DIVERSION SUMMARY")

    for column in ["Is_Cancelled", "Is_Diverted"]:
        counts = flight_df[column].value_counts(dropna=False)
        print(f"\n{column} counts:")
        print(counts)

        rate = flight_df[column].mean() * 100
        print(f"{column} percentage: {rate:.2f}%")

    # 4. Passenger satisfaction distribution
    print("\nPASSENGER SATISFACTION DISTRIBUTION")

    satisfaction_counts = (
        satisfaction_df["Actual_Satisfaction"]
        .value_counts(dropna=False)
    )

    print(satisfaction_counts)

    satisfaction_percentages = (
        satisfaction_df["Actual_Satisfaction"]
        .value_counts(normalize=True, dropna=False)
        .mul(100)
        .round(2)
    )

    print("\nSatisfaction percentages:")
    print(satisfaction_percentages)

    # 5. Save summary outputs
    flight_df.describe(include="all").to_csv(
        "outputs/flight_operations_descriptive_statistics.csv"
    )

    satisfaction_df.describe(include="all").to_csv(
        "outputs/passenger_satisfaction_descriptive_statistics.csv"
    )

    satisfaction_counts.rename("Count").to_csv(
        "outputs/satisfaction_distribution.csv"
    )

    print("\nEDA completed. Results saved in the outputs folder.")

finally:
    connection.close()
    print("\nMySQL connection closed.")