DROP PROCEDURE IF EXISTS GET_StateEmissions;

DELIMITER $$

CREATE PROCEDURE GET_StateEmissions(
    IN ARG_State VARCHAR(30),
    IN ARG_Year INT
)
BEGIN
    SELECT *
    FROM dbo.State_CO2_Emissions CO2
    WHERE CO2.State = ARG_State
	AND CO2.Year = ARG_Year;
END$$

DELIMITER ;
