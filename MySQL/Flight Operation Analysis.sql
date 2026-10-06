USE AeroNexus;

-- Change data types in Flight_Operations
ALTER TABLE Flight_Operations
    MODIFY Flight_ID VARCHAR(50),
    MODIFY Airline_ID INT,
    MODIFY Origin_Airport_ID INT,
    MODIFY Dest_Airport_ID INT,
    MODIFY Tail_Number VARCHAR(20),
    MODIFY Dep_Time_Block VARCHAR(30),
    MODIFY Arr_Time_Block VARCHAR(30),
    MODIFY Cancel_Code VARCHAR(10),
    MODIFY Div1_Airport VARCHAR(10),
    MODIFY Div2_Airport VARCHAR(10);

-- 1. Check table structure
DESCRIBE flight_operations;
DESCRIBE Airline;

-- 2. Check total rows
SELECT COUNT(*) AS total_rows
FROM flight_operations;

-- 3. Check total columns
SELECT COUNT(*) AS total_columns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'AeroNexus'
  AND TABLE_NAME = 'flight_operations';

-- 4. Check duplicate Flight_ID values
SELECT Flight_ID, COUNT(*) AS occurrences
FROM flight_operations
GROUP BY Flight_ID
HAVING COUNT(*) > 1;

-- 5. Check NULL values in key columns
SELECT
    SUM(Flight_ID IS NULL) AS null_flight_id,
    SUM(Flight_Date IS NULL) AS null_flight_date,
    SUM(Carrier_Code IS NULL) AS null_airline_code,
    SUM(Origin_IATA_Code IS NULL) AS null_origin,
    SUM(Dest_IATA_Code IS NULL) AS null_destination,
    SUM(Is_Cancelled IS NULL) AS null_cancelled,
    SUM(Is_Diverted IS NULL) AS null_diverted
FROM flight_operations;

-- 6. Check cancellation counts
SELECT
    Is_Cancelled,
    COUNT(*) AS flight_count
FROM flight_operations
GROUP BY Is_Cancelled
ORDER BY Is_Cancelled;

-- 7. Check cancellation codes
SELECT
    Cancel_Code,
    COUNT(*) AS flight_count
FROM flight_operations
GROUP BY Cancel_Code
ORDER BY flight_count DESC;

-- 8. Check cancellation-code consistency
SELECT
    SUM(
        Is_Cancelled = 0
        AND Cancel_Code IS NOT NULL
        AND TRIM(Cancel_Code) <> ''
        AND UPPER(TRIM(Cancel_Code)) <> 'N/A'
    ) AS non_cancelled_with_code,
    SUM(
        Is_Cancelled = 1
        AND (
            Cancel_Code IS NULL
            OR TRIM(Cancel_Code) = ''
            OR UPPER(TRIM(Cancel_Code)) = 'N/A'
        )
    ) AS cancelled_without_code
FROM flight_operations;

-- 9. Check diversion counts
SELECT
    Is_Diverted,
    COUNT(*) AS flight_count
FROM flight_operations
GROUP BY Is_Diverted
ORDER BY Is_Diverted;

-- 10. Check diversion landing and destination status
SELECT
    Is_Diverted,
    COUNT(*) AS flight_count,
    SUM(Is_Diverted = 1 AND Div_Reached_Dest IS NULL) AS diverted_missing_destination_status
FROM flight_operations
GROUP BY Is_Diverted;

-- 11. Check departure delay range
SELECT
    MIN(Dep_Delay_Min) AS minimum_departure_delay,
    MAX(Dep_Delay_Min) AS maximum_departure_delay,
    AVG(Dep_Delay_Min) AS average_departure_delay
FROM flight_operations;

-- 12. Check arrival delay range
SELECT
    MIN(Arr_Delay_Min) AS minimum_arrival_delay,
    MAX(Arr_Delay_Min) AS maximum_arrival_delay,
    AVG(Arr_Delay_Min) AS average_arrival_delay
FROM flight_operations;

-- 13. Check distance and duration ranges
SELECT
    MIN(Distance_Miles) AS minimum_distance,
    MAX(Distance_Miles) AS maximum_distance,
    MIN(Actual_Elapsed_Time_Min) AS minimum_elapsed_time,
    MAX(Actual_Elapsed_Time_Min) AS maximum_elapsed_time
FROM flight_operations;

-- 14. Check delay-cause ranges
SELECT
    MIN(Carrier_Delay_Min) AS min_carrier_delay,
    MAX(Carrier_Delay_Min) AS max_carrier_delay,
    MIN(Weather_Delay_Min) AS min_weather_delay,
    MAX(Weather_Delay_Min) AS max_weather_delay,
    MIN(NAS_Delay_Min) AS min_nas_delay,
    MAX(NAS_Delay_Min) AS max_nas_delay,
    MIN(Security_Delay_Min) AS min_security_delay,
    MAX(Security_Delay_Min) AS max_security_delay,
    MIN(Late_Aircraft_Delay_Min) AS min_late_aircraft_delay,
    MAX(Late_Aircraft_Delay_Min) AS max_late_aircraft_delay
FROM flight_operations;

-- 15. Check departure and arrival time values
SELECT
    COUNT(*) AS total_rows,
    SUM(Actual_Dep_Time IS NULL) AS null_departure_time,
    SUM(Actual_Arr_Time IS NULL) AS null_arrival_time
FROM flight_operations;

-- 16. Check distinct departure time values
SELECT DISTINCT Actual_Dep_Time
FROM flight_operations
ORDER BY Actual_Dep_Time
LIMIT 30;

-- 17. Check distinct arrival time values
SELECT DISTINCT Actual_Arr_Time
FROM flight_operations
ORDER BY Actual_Arr_Time
LIMIT 30;

-- 18. Check departure time blocks
SELECT
    CASE
        WHEN Actual_Dep_Time IS NULL THEN 'Unknown'
        WHEN HOUR(Actual_Dep_Time) BETWEEN 5 AND 11 THEN 'Morning'
        WHEN HOUR(Actual_Dep_Time) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN HOUR(Actual_Dep_Time) BETWEEN 17 AND 20 THEN 'Evening'
        ELSE 'Night'
    END AS departure_time_block,
    COUNT(*) AS flight_count
FROM flight_operations
GROUP BY Departure_Time_Block
ORDER BY flight_count DESC;

-- 19. Check arrival time blocks
SELECT
    CASE
        WHEN Actual_Arr_Time IS NULL THEN 'Unknown'
        WHEN HOUR(Actual_Arr_Time) BETWEEN 5 AND 11 THEN 'Morning'
        WHEN HOUR(Actual_Arr_Time) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN HOUR(Actual_Arr_Time) BETWEEN 17 AND 20 THEN 'Evening'
        ELSE 'Night'
    END AS arrival_time_block,
    COUNT(*) AS flight_count
FROM flight_operations
GROUP BY Arrival_Time_Block
ORDER BY flight_count DESC;

-- 20. View sample flight records
SELECT *
FROM flight_operations
LIMIT 10;