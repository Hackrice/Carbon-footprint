CREATE TABLE dbo.State_CO2_Emissions(
	ID INT PRIMARY KEY NOT NULL,
	State VARCHAR(30) NOT NULL,
	City VARCHAR(30) NOT NULL,
	Year INT NOT NULL,
	Month VARCHAR(25) NOT NULL,
	CO2_Emission VARCHAR(20) NOT NULL
);
