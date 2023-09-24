CREATE TABLE dbo.CustomerDataForm(
        Email_ID VARCHAR(55) PRIMARY KEY NOT NULL,
        State VARCHAR(55) NOT NULL,
        City VARCHAR(55) NOT NULL,
        Vehicle_Type VARCHAR(55),
        Commute_Miles INT,
        Commute_Time INT,
	Electrical_Usage INT
);
