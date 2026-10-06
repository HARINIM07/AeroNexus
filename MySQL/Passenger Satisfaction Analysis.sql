CREATE DATABASE IF NOT EXISTS AeroNexus;
USE AeroNexus;

-- Change data types in Passenger_Satisfaction
ALTER TABLE Passenger_Satisfaction
    MODIFY Flight_ID VARCHAR(50),
    MODIFY Passenger_ID VARCHAR(50),
    MODIFY Passenger_Name VARCHAR(100),
    MODIFY Gender VARCHAR(20),
    MODIFY Passenger_Type VARCHAR(50),
    MODIFY Ticket_Price DECIMAL(10,2),
    MODIFY Class VARCHAR(30),
    MODIFY Travel_Type VARCHAR(30),
    MODIFY Actual_Satisfaction VARCHAR(20);

-- 1. Check table structure
DESCRIBE passenger_satisfaction;

-- 2. Check total rows
SELECT COUNT(*) AS total_rows
FROM passenger_satisfaction;

-- 3. Check total columns
SELECT COUNT(*) AS total_columns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'AeroNexus'
  AND TABLE_NAME = 'passenger_satisfaction';

-- 4. Check duplicate Satisfaction_ID values
SELECT Satisfaction_ID, COUNT(*) AS occurrences
FROM passenger_satisfaction
GROUP BY Satisfaction_ID
HAVING COUNT(*) > 1;

-- 5. Check NULL values in important columns
SELECT
    SUM(Satisfaction_ID IS NULL) AS null_satisfaction_id,
    SUM(Flight_ID IS NULL) AS null_flight_id,
    SUM(Passenger_ID IS NULL) AS null_passenger_id,
    SUM(Age IS NULL) AS null_age,
    SUM(Gender IS NULL) AS null_gender,
    SUM(Passenger_Type IS NULL) AS null_passenger_type,
    SUM(Class IS NULL) AS null_class,
    SUM(Travel_Type IS NULL) AS null_travel_type,
    SUM(Satisfaction IS NULL) AS null_satisfaction
FROM passenger_satisfaction;

-- 6. Check distinct categorical values
SELECT DISTINCT Actual_Satisfaction
FROM passenger_satisfaction;

SELECT DISTINCT Class
FROM passenger_satisfaction;

SELECT DISTINCT Travel_Type
FROM passenger_satisfaction;

SELECT DISTINCT Passenger_Type
FROM passenger_satisfaction;

SELECT DISTINCT Gender
FROM passenger_satisfaction;

-- 7. Check age and ticket price ranges
SELECT
    MIN(Age) AS minimum_age,
    MAX(Age) AS maximum_age,
    MIN(Ticket_Price) AS minimum_ticket_price,
    MAX(Ticket_Price) AS maximum_ticket_price
FROM passenger_satisfaction;

-- 8. Check service rating ranges
SELECT
    MIN(Seat_Comfort) AS min_seat_comfort,
    MAX(Seat_Comfort) AS max_seat_comfort,
    MIN(Food_and_Drink) AS min_food_and_drink,
    MAX(Food_and_Drink) AS max_food_and_drink,
    MIN(Inflight_Entertainment) AS min_inflight_entertainment,
    MAX(Inflight_Entertainment) AS max_inflight_entertainment,
    MIN(Online_Boarding) AS min_online_boarding,
    MAX(Online_Boarding) AS max_online_boarding,
    MIN(Checkin_Service) AS min_checkin_service,
    MAX(Checkin_Service) AS max_checkin_service
FROM passenger_satisfaction;

-- 9. View sample records
SELECT *
FROM passenger_satisfaction
LIMIT 10;

-- 10. Check satisfaction distribution
SELECT
    Actual_Satisfaction,
    COUNT(*) AS passenger_count
FROM passenger_satisfaction
GROUP BY Actual_Satisfaction
ORDER BY passenger_count DESC;

-- 11. Calculate satisfaction percentages
SELECT
    Actual_Satisfaction,
    COUNT(*) AS passenger_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM passenger_satisfaction),
        2
    ) AS percentage
FROM passenger_satisfaction
GROUP BY Actual_Satisfaction
ORDER BY passenger_count DESC;

-- 12. Analyse satisfaction by class
SELECT
    Class,
    Actual_Satisfaction,
    COUNT(*) AS passenger_count
FROM passenger_satisfaction
GROUP BY Class, Actual_Satisfaction
ORDER BY Class, passenger_count DESC;

-- 13. Analyse satisfaction by travel type
SELECT
    Travel_Type,
    Actual_Satisfaction,
    COUNT(*) AS passenger_count
FROM passenger_satisfaction
GROUP BY Travel_Type, Actual_Satisfaction
ORDER BY Travel_Type, passenger_count DESC;

-- 14. Analyse satisfaction by passenger type
SELECT
    Passenger_Type,
    Actual_Satisfaction,
    COUNT(*) AS passenger_count
FROM passenger_satisfaction
GROUP BY Passenger_Type, Actual_Satisfaction
ORDER BY Passenger_Type, passenger_count DESC;

-- 15. Compare average ticket price by satisfaction
SELECT
    Actual_Satisfaction,
    ROUND(AVG(Ticket_Price), 2) AS average_ticket_price
FROM passenger_satisfaction
GROUP BY Actual_Satisfaction
ORDER BY average_ticket_price DESC;

-- 16. Compare average service ratings by satisfaction
SELECT
    Actual_Satisfaction,
    ROUND(AVG(Seat_Comfort), 2) AS avg_seat_comfort,
    ROUND(AVG(Food_and_Drink), 2) AS avg_food_and_drink,
    ROUND(AVG(Inflight_Entertainment), 2) AS avg_inflight_entertainment,
    ROUND(AVG(Online_Boarding), 2) AS avg_online_boarding,
    ROUND(AVG(Checkin_Service), 2) AS avg_checkin_service
FROM passenger_satisfaction
GROUP BY Actual_Satisfaction
ORDER BY Actual_Satisfaction;

-- 17. Calculate overall average service ratings
SELECT
    ROUND(AVG(Seat_Comfort), 2) AS avg_seat_comfort,
    ROUND(AVG(Food_and_Drink), 2) AS avg_food_and_drink,
    ROUND(AVG(Inflight_Entertainment), 2) AS avg_inflight_entertainment,
    ROUND(AVG(Online_Boarding), 2) AS avg_online_boarding,
    ROUND(AVG(Checkin_Service), 2) AS avg_checkin_service
FROM passenger_satisfaction;

-- 18. Analyse satisfaction by age group
SELECT
    CASE
        WHEN Age < 18 THEN 'Under 18'
        WHEN Age BETWEEN 18 AND 29 THEN '18-29'
        WHEN Age BETWEEN 30 AND 44 THEN '30-44'
        WHEN Age BETWEEN 45 AND 59 THEN '45-59'
        ELSE '60 and above'
    END AS age_group,
    Actual_Satisfaction,
    COUNT(*) AS passenger_count
FROM passenger_satisfaction
GROUP BY age_group, Actual_Satisfaction
ORDER BY age_group, Actual_Satisfaction;

-- 19. Analyse satisfaction by class and travel type
SELECT
    Class,
    Travel_Type,
    Actual_Satisfaction,
    COUNT(*) AS passenger_count
FROM passenger_satisfaction
GROUP BY Class, Travel_Type, Actual_Satisfaction
ORDER BY Class, Travel_Type, passenger_count DESC;

-- 20. Check duplicate complete rows
SELECT
    COUNT(*) AS duplicate_group_count
FROM (
    SELECT
        Passenger_ID,
        Flight_ID,
        Age,
        Gender,
        Passenger_Type,
        Class,
        Travel_Type,
        Actual_Satisfaction
    FROM passenger_satisfaction
    GROUP BY
        Passenger_ID,
        Flight_ID,
        Age,
        Gender,
        Passenger_Type,
        Class,
        Travel_Type,
        Actual_Satisfaction
    HAVING COUNT(*) > 1
) AS duplicates;