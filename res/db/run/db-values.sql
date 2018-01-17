USE sensei;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT
	s.SensorName,
	s.Measure,
    s.Unit,
    s.Value,
    s.DateField,
	FLOOR(TIMEDIFF(NOW(), STR_TO_DATE(s.DateField,'%Y%m%d%H%i%S')) +0) AS Age
FROM sensors_values AS s
	INNER JOIN
    (
		SELECT SensorName, Measure, Unit, MAX(DateField) AS DateField
        FROM sensors_values
        WHERE DateField > ((NOW() - INTERVAL 35 MINUTE) + 0) 
		GROUP BY SensorName, Measure, Unit
	) AS sl
		ON s.SensorName = sl.SensorName
			AND s.Measure=sl.Measure
            AND s.Unit=sl.Unit
            AND s.DateField=sl.DateField
