#!/bin/bash

# Sensei Port Start
# ======================
# Start all the service needed for a port

echo "# Port start $PORT: starting...."

sleep $USB_CONN_WAIT
PORT_OUT=$($DIR/sensei-discover-port $PORT)
>&3 echo -e "$PORT_OUT"
discoveredDevice="$(echo -e "$PORT_OUT" | grep -Po '(# Discovered .*)')"
if [[ -z "$discoveredDevice" ]]; then
  echo "No device discovered on port $PORT"
else
  echo $discoveredDevice
  ($DIR/sensei-master-start "$PORT") &
  if [ $? -eq 0 ]; then
    sleep 5
    $DIR/sensei-master-check "$PORT"
    if [ $? -eq 0 ]; then
      echo "# Port start $PORT: starting data flow..."
      (>&3 $DIR/sensei-scheduler "$PORT") &
      #(>&3 $DIR/sensei-log-sensors "$PORT") &
      echo "# Port start $PORT: started."
    else
        >&2 echo "FAILED to start port $PORT"
    fi
  fi
fi
