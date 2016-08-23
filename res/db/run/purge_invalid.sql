DELETE FROM sensors_values
	 WHERE DateField > (NOW() - INTERVAL 90 SECOND)+0
	 AND(
		IFNULL(Value,'') = ''
		OR IFNULL(Measure,'') = ''
		OR Measure LIKE  '% %'
		OR IFNULL(SensorName,'') = ''
		OR SensorName LIKE  '% %'
		OR SensorName LIKE  '>%'
	);
