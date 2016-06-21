#!/bin/bash

# Sensei Port Stop
# ======================
# Stops all the service needed for a port

echo "# Port stop $PORT: stopping...."

$DIR/sensei-master-stop "$PORT" -f
sleep 1
$DIR/sensei-discard-port "$PORT"
pkill -f "sensei-scheduler $PORT"
pkill -f "sensei-log-sensors $PORT"
