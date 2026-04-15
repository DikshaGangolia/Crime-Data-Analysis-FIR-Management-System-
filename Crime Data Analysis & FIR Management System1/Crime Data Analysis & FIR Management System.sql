DROP DATABASE IF EXISTS CrimeSystem;
CREATE DATABASE CrimeSystem;
USE CrimeSystem;
CREATE TABLE Officers (
    officer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    officer_rank VARCHAR(50),
    station VARCHAR(100)
);
CREATE TABLE Criminals (
    criminal_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    age INT,
    crime_type VARCHAR(100),
    previous_cases INT DEFAULT 0
);
CREATE TABLE FIR (
    fir_id INT PRIMARY KEY AUTO_INCREMENT,
    date_filed DATE,
    area VARCHAR(100),
    crime_type VARCHAR(100),
    officer_id INT,
    status VARCHAR(50),
    FOREIGN KEY (officer_id) REFERENCES Officers(officer_id)
);
CREATE TABLE Cases (
    case_id INT PRIMARY KEY AUTO_INCREMENT,
    fir_id INT,
    criminal_id INT,
    verdict VARCHAR(50),
    FOREIGN KEY (fir_id) REFERENCES FIR(fir_id),
    FOREIGN KEY (criminal_id) REFERENCES Criminals(criminal_id)
);
-- Officers
INSERT INTO Officers (name, officer_rank, station) VALUES
('Raj Sharma', 'Inspector', 'Delhi'),
('Amit Singh', 'SI', 'Mumbai'),
('Neha Verma', 'DSP', 'Delhi');

-- Criminals
INSERT INTO Criminals (name, age, crime_type, previous_cases) VALUES
('Ravi Kumar', 30, 'Theft', 2),
('Sohan Lal', 40, 'Murder', 5),
('Vikas Yadav', 25, 'Robbery', 1);

-- FIR
INSERT INTO FIR (date_filed, area, crime_type, officer_id, status) VALUES
('2025-01-10', 'Delhi', 'Theft', 1, 'Open'),
('2025-02-15', 'Mumbai', 'Murder', 2, 'Closed'),
('2025-03-05', 'Delhi', 'Robbery', 3, 'Open');

-- Cases
INSERT INTO Cases (fir_id, criminal_id, verdict) VALUES
(1, 1, 'Pending'),
(2, 2, 'Guilty'),
(3, 3, 'Pending');
SELECT area, COUNT(*) AS total_crimes
FROM FIR
GROUP BY area
ORDER BY total_crimes DESC;
SELECT name, previous_cases
FROM Criminals
WHERE previous_cases > 1;
SELECT 
    COUNT(CASE WHEN status = 'Closed' THEN 1 END) * 100.0 / COUNT(*) AS resolution_rate
FROM FIR;
SELECT o.name, COUNT(f.fir_id) AS total_cases
FROM Officers o
LEFT JOIN FIR f ON o.officer_id = f.officer_id
GROUP BY o.name;
SELECT area, COUNT(*) AS total_crimes,
RANK() OVER (ORDER BY COUNT(*) DESC) AS rank_area
FROM FIR
GROUP BY area;
SELECT 
    f.fir_id,
    f.area,
    f.crime_type,
    c.name AS criminal_name,
    o.name AS officer_name,
    cs.verdict
FROM FIR f
JOIN Cases cs ON f.fir_id = cs.fir_id
JOIN Criminals c ON cs.criminal_id = c.criminal_id
JOIN Officers o ON f.officer_id = o.officer_id;
CREATE INDEX idx_area ON FIR(area);
CREATE INDEX idx_crime_type ON FIR(crime_type);
CREATE VIEW CrimeSummary AS
SELECT area, COUNT(*) AS total_cases
FROM FIR
GROUP BY area;
CREATE USER 'officer_user'@'localhost' IDENTIFIED BY 'password';

GRANT SELECT, INSERT ON CrimeSystem.FIR TO 'officer_user'@'localhost';
GRANT SELECT ON CrimeSystem.Criminals TO 'officer_user'@'localhost';