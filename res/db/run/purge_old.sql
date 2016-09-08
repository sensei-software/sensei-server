DELETE FROM sensors_log
         WHERE EventTime < (NOW() - INTERVAL 60 SECOND)+0;

DELETE FROM sensors_values
         WHERE DateField < (NOW() - INTERVAL 60 MINUTE)+0;

DELETE FROM sensors_values_m
         WHERE DateField < (NOW() - INTERVAL 24 HOUR)+0;

DELETE FROM calendar_s
         WHERE DateField < (NOW() - INTERVAL 24 HOUR)+0;
