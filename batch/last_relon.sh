#!/bin/bash
DIR="/home/sensei/sensei/sensei-server/bin"

THRESHOLD="0.01"
PRECISION="_h"
$DIR/sensei-db-command "SELECT STR_TO_DATE(DateField,'%Y%m%d%H%i%s') FROM sensors_values$PRECISION WHERE SensorName = 'Relays>R$1' AND Measure = 'REL_STATUS' AND Value>$THRESHOLD ORDER BY DateField DESC LIMIT 0,1" -B -N

