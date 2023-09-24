DROP PROCEDURE IF EXISTS GET_CityMonthYearPercentile;

DELIMITER $$

CREATE PROCEDURE GET_CityMonthYearPercentile(
    IN ARG_Month VARCHAR(30),
    IN ARG_Year INT
)
BEGIN
    SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY CO2_Emission DESC) AS RowNumber, City, CO2_Emission
	FROM State_CO2_Emissions CO2
	WHERE CO2.Month = ARG_Month
	AND CO2.Year = ARG_Year
	ORDER BY CO2_Emission DESC;
END$$

DELIMITER ;
