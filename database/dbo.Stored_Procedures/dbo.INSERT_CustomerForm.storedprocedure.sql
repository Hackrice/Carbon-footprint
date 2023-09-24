
CREATE PROCEDURE InsertCustomer(
    IN ARG_Email_ID VARCHAR(55),
    IN ARG_State VARCHAR(55),
    IN ARG_City VARCHAR(55),
    IN ARG_Vehicle_Type VARCHAR(55),
    IN ARG_Commute_Miles INT,
    IN ARG_Commute_Time INT,
    IN ARG_Electrical_Usage INT
)

BEGIN
    INSERT INTO CustomerDataForm(Email_ID, State, City, Vehicle_Type, Commute_Miles, Commute_Time, Electrical_Usage)
    VALUES (ARG_Email_ID, ARG_State, ARG_City, ARG_Vehicle_Type, ARG_Commute_Miles, ARG_Commute_Time, ARG_Electrical_Usage);
END;




