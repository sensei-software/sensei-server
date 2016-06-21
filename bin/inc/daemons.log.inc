#!/bin/bash

# Add timestamp and copy outputs to log
exec 1> >( $DIR/tools/ts "%Y/%m/%d %H:%M:%S - $(basename ${0}) - INFO ($PORT_NAME-$DEV_ID-$DEV_NAME): " | tee -a $LOG_DIR/sensei.log )
exec 2> >( $DIR/tools/ts "%Y/%m/%d %H:%M:%S - $(basename ${0}) - ERROR ($PORT_NAME-$DEV_ID-$DEV_NAME): " | tee -a $LOG_DIR/sensei.log $LOG_DIR/sensei_errors.log >&2)
if [[ "$DEBUG_MODE" == "on" ]]; then
  exec 3> >( $DIR/tools/ts "%Y/%m/%d %H:%M:%S - $(basename ${0}) - DEBUG ($PORT_NAME-$DEV_ID-$DEV_NAME): " | tee -a $LOG_DIR/sensei.log )
else
  exec 3> /dev/null
fi

# Add KILL signals logging
trap '>&2 echo "WARNING: kill signal received" |  ts "%Y/%m/%d %H:%M:%S - $(basename ${0}) - INFO: " | tee -a $LOG_DIR/sensei.log; exit 255' SIGINT
