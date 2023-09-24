LOAD DATA LOCAL
INFILE "../emession.csv"
INTO TABLE dbo.State_CO2_Emissions
FIELDS TERMINATED BY ',';
