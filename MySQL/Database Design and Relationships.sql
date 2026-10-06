USE AeroNexus;

-- 1. Describe Flight_Operations
DESCRIBE Flight_Operations;

-- 2. Describe Passenger_Satisfaction
DESCRIBE Passenger_Satisfaction;

-- 3. Check duplicate Flight_ID values in Flight_Operations
SELECT
    Flight_ID,
    COUNT(*) AS occurrences
FROM Flight_Operations
GROUP BY Flight_ID
HAVING COUNT(*) > 1;

-- 4. Check duplicate Passenger_ID values in Passenger_Satisfaction
-- A Passenger_ID may legitimately appear more than once.
SELECT
    Passenger_ID,
    COUNT(*) AS occurrences
FROM Passenger_Satisfaction
GROUP BY Passenger_ID
HAVING COUNT(*) > 1;

-- 5. Check Flight_Operations records with Flight_ID = 0 or missing IDs
SELECT *
FROM Flight_Operations
WHERE Flight_ID IS NULL
   OR TRIM(Flight_ID) = ''
   OR TRIM(Flight_ID) = '0';

-- 6. Check Passenger_Satisfaction records with Passenger_ID = 0 or missing IDs
SELECT *
FROM Passenger_Satisfaction
WHERE Passenger_ID IS NULL
   OR TRIM(Passenger_ID) = ''
   OR TRIM(Passenger_ID) = '0';
   
-- 7. Create Airline dimension
CREATE TABLE Airline (
    Airline_ID INT PRIMARY KEY,
    Airline_Name VARCHAR(100),
    Carrier_Code VARCHAR(10),
    Airline_Country VARCHAR(100)
);

-- 8. Populate Airline dimension
INSERT INTO Airline SELECT DISTINCT Airline_ID, Airline_Name, Carrier_Code, Airline_Country FROM flight_operations;

-- 9. Create Airport dimension
CREATE TABLE Airport (
    Airport_ID INT PRIMARY KEY,
    IATA_Code VARCHAR(10),
    Airport_Name VARCHAR(150),
    Airport_City VARCHAR(100),
    Airport_State VARCHAR(100),
    Airport_Country VARCHAR(100),
    Latitude DECIMAL(10,6),
    Longitude DECIMAL(10,6)
);

-- 10. Populate Airport dimension with origin and destination airports
INSERT INTO Airport SELECT DISTINCT
    Origin_Airport_ID,
    Origin_IATA_Code,
    Origin_Airport_Name,
    Origin_City,
    Origin_State,
    Origin_Country,
    Origin_Latitude,
    Origin_Longitude
FROM flight_operations;

-- 11. Create Passenger dimension
CREATE TABLE Passenger (
    Passenger_ID VARCHAR(50) PRIMARY KEY,
    Passenger_Name VARCHAR(100),
    Age INT,
    Gender VARCHAR(20),
    Passenger_Type VARCHAR(50)
);

-- 12. Populate Passenger dimension
-- Group by Passenger_ID because one passenger may have multiple satisfaction records.
INSERT INTO Passenger SELECT Passenger_ID, Passenger_Name, Age, Gender, Passenger_Type FROM passenger_satisfaction;

-- 13. Drop unwanted descriptive columns from Flight_Operations
ALTER TABLE Flight_Operations
    DROP COLUMN Airline_Name,
    DROP COLUMN Carrier_Code,
    DROP COLUMN Airline_Country,
    DROP COLUMN Origin_IATA_Code,
    DROP COLUMN Origin_Airport_Name,
    DROP COLUMN Origin_City,
    DROP COLUMN Origin_State,
    DROP COLUMN Origin_Country,
    DROP COLUMN Origin_Latitude,
    DROP COLUMN Origin_Longitude,
    DROP COLUMN Dest_IATA_Code,
    DROP COLUMN Dest_Airport_Name,
    DROP COLUMN Dest_City,
    DROP COLUMN Dest_State,
    DROP COLUMN Dest_Country,
    DROP COLUMN Dest_Latitude,
    DROP COLUMN Dest_Longitude;

-- 14. Drop unwanted descriptive columns from Passenger_Satisfaction
-- Passenger details have already been copied into Passenger in Step 12.
ALTER TABLE Passenger_Satisfaction
    DROP COLUMN Passenger_Name,
    DROP COLUMN Age,
    DROP COLUMN Gender,
    DROP COLUMN Passenger_Type;

-- 15.1. Check Flight_ID values before creating the primary key
SELECT
    Flight_ID,
    COUNT(*) AS occurrences
FROM Flight_Operations
GROUP BY Flight_ID
HAVING Flight_ID IS NULL
    OR COUNT(*) > 1;

-- 15.2. Check Satisfaction_ID values before creating the primary key
SELECT
    Satisfaction_ID,
    COUNT(*) AS occurrences
FROM Passenger_Satisfaction
GROUP BY Satisfaction_ID
HAVING Satisfaction_ID IS NULL
    OR COUNT(*) > 1;

-- 15.3. Check unmatched Airline_ID values
SELECT DISTINCT f.Airline_ID
FROM Flight_Operations AS f
LEFT JOIN Airline AS a
    ON f.Airline_ID = a.Airline_ID
WHERE f.Airline_ID IS NOT NULL
  AND a.Airline_ID IS NULL;

-- 15.4. Check unmatched origin airport IDs
SELECT DISTINCT f.Origin_Airport_ID
FROM Flight_Operations AS f
LEFT JOIN Airport AS a
    ON f.Origin_Airport_ID = a.Airport_ID
WHERE f.Origin_Airport_ID IS NOT NULL
  AND a.Airport_ID IS NULL;

-- 15.5. Check unmatched destination airport IDs
SELECT DISTINCT f.Dest_Airport_ID
FROM Flight_Operations AS f
LEFT JOIN Airport AS a
    ON f.Dest_Airport_ID = a.Airport_ID
WHERE f.Dest_Airport_ID IS NOT NULL
  AND a.Airport_ID IS NULL;

-- 15.6. Check unmatched Flight_ID values in Passenger_Satisfaction
SELECT DISTINCT ps.Flight_ID
FROM Passenger_Satisfaction AS ps
LEFT JOIN Flight_Operations AS f
    ON ps.Flight_ID = f.Flight_ID
WHERE ps.Flight_ID IS NOT NULL
  AND f.Flight_ID IS NULL;

-- 15.7. Check unmatched Passenger_ID values
SELECT DISTINCT ps.Passenger_ID
FROM Passenger_Satisfaction AS ps
LEFT JOIN Passenger AS p
    ON ps.Passenger_ID = p.Passenger_ID
WHERE ps.Passenger_ID IS NOT NULL
  AND p.Passenger_ID IS NULL;

-- 15.8. Create primary key on Flight_Operations
ALTER TABLE Flight_Operations
    ADD PRIMARY KEY (Flight_ID);

-- 15.9. Create primary key on Passenger_Satisfaction
ALTER TABLE Passenger_Satisfaction
    ADD PRIMARY KEY (Satisfaction_ID);

-- 15.10. Create foreign key from Passenger_Satisfaction to Flight_Operations
ALTER TABLE Passenger_Satisfaction
    ADD CONSTRAINT fk_satisfaction_flight
    FOREIGN KEY (Flight_ID)
    REFERENCES Flight_Operations (Flight_ID);

-- 15.11. Create foreign key from Passenger_Satisfaction to Passenger
ALTER TABLE Passenger_Satisfaction
    ADD CONSTRAINT fk_satisfaction_passenger
    FOREIGN KEY (Passenger_ID)
    REFERENCES Passenger (Passenger_ID);

-- 15.12. Create foreign key from Flight_Operations to Airline
ALTER TABLE Flight_Operations
    ADD CONSTRAINT fk_flight_airline
    FOREIGN KEY (Airline_ID)
    REFERENCES Airline (Airline_ID);

-- 15.13. Create foreign key from Flight_Operations to origin Airport
ALTER TABLE Flight_Operations
    ADD CONSTRAINT fk_flight_origin_airport
    FOREIGN KEY (Origin_Airport_ID)
    REFERENCES Airport (Airport_ID);

-- 15.14. Create foreign key from Flight_Operations to destination Airport
ALTER TABLE Flight_Operations
    ADD CONSTRAINT fk_flight_dest_airport
    FOREIGN KEY (Dest_Airport_ID)
    REFERENCES Airport (Airport_ID);

-- 16.1. Join Flight_Operations with Airline
SELECT
    f.Flight_ID,
    f.Airline_ID,
    a.Airline_Name,
    a.Carrier_Code,
    a.Airline_Country
FROM Flight_Operations AS f
LEFT JOIN Airline AS a
    ON f.Airline_ID = a.Airline_ID
LIMIT 20;

-- 16.2. Join Flight_Operations with origin Airport
SELECT
    f.Flight_ID,
    f.Origin_Airport_ID,
    a.IATA_Code,
    a.Airport_Name,
    a.Airport_City
FROM Flight_Operations AS f
LEFT JOIN Airport AS a
    ON f.Origin_Airport_ID = a.Airport_ID
LIMIT 20;

-- 16.3. Join Flight_Operations with destination Airport
SELECT
    f.Flight_ID,
    f.Dest_Airport_ID,
    a.IATA_Code,
    a.Airport_Name,
    a.Airport_City
FROM Flight_Operations AS f
LEFT JOIN Airport AS a
    ON f.Dest_Airport_ID = a.Airport_ID
LIMIT 20;

-- 16.4. Join Passenger_Satisfaction with Passenger
SELECT
    ps.Satisfaction_ID,
    ps.Passenger_ID,
    p.Passenger_Name,
    p.Age,
    p.Gender,
    p.Passenger_Type
FROM Passenger_Satisfaction AS ps
LEFT JOIN Passenger AS p
    ON ps.Passenger_ID = p.Passenger_ID
LIMIT 20;

-- 16.5. Join Passenger_Satisfaction with Flight_Operations
SELECT
    ps.Satisfaction_ID,
    ps.Flight_ID,
    ps.Actual_Satisfaction,
    f.Flight_Date,
    f.Airline_ID,
    f.Origin_Airport_ID,
    f.Dest_Airport_ID
FROM Passenger_Satisfaction AS ps
LEFT JOIN Flight_Operations AS f
    ON ps.Flight_ID = f.Flight_ID
LIMIT 20;

-- 17. Combine all five tables into one result
SELECT
    f.Flight_ID,
    f.Flight_Date,
    f.Airline_ID,
    a.Airline_Name,
    a.Carrier_Code,
    origin_airport.IATA_Code AS Origin_IATA_Code,
    origin_airport.Airport_Name AS Origin_Airport_Name,
    origin_airport.Airport_City AS Origin_City,
    destination_airport.IATA_Code AS Dest_IATA_Code,
    destination_airport.Airport_Name AS Dest_Airport_Name,
    destination_airport.Airport_City AS Dest_City,
    ps.Satisfaction_ID,
    ps.Passenger_ID,
    p.Passenger_Name,
    p.Age,
    p.Gender,
    p.Passenger_Type,
    ps.Class,
    ps.Travel_Type,
    ps.Ticket_Price,
    ps.Actual_Satisfaction
FROM Flight_Operations AS f
LEFT JOIN Airline AS a
    ON f.Airline_ID = a.Airline_ID
LEFT JOIN Airport AS origin_airport
    ON f.Origin_Airport_ID = origin_airport.Airport_ID
LEFT JOIN Airport AS destination_airport
    ON f.Dest_Airport_ID = destination_airport.Airport_ID
LEFT JOIN Passenger_Satisfaction AS ps
    ON f.Flight_ID = ps.Flight_ID
LEFT JOIN Passenger AS p
    ON ps.Passenger_ID = p.Passenger_ID
LIMIT 100;