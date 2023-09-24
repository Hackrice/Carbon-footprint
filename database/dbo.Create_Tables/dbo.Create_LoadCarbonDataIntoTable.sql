LOAD DATA LOCAL
INFILE "../mock_carbon_data.csv"
INTO TABLE dbo.CustomerData
FIELDS TERMINATED BY ',';
