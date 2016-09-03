#!/bin/bash

# Port Parsing
PORT_ARG="$1"
PORT_PATH="$(echo "$PORT_ARG" | grep /tty)"
if [[ ! -z "$PORT_PATH" ]]; then
    PORT_NAME="$(echo "$PORT_PATH" | cut -d '/' -f3 )"
else
  # If is not /dev/tty* format, alias is assumed
  if [[ ! -z "$PORT_ARG" ]]; then
    PORT_ALIAS="$PORT_ARG"
    if [[ ! -d "$DEV_DIR/$PORT_ALIAS" ]]; then
      >&2 echo "Port alias '$PORT_ALIAS' not found."
      exit 202
    else
      # decode port alias
      PORT_NAME=$(readlink $DEV_DIR/$PORT_ALIAS | rev | cut -d '/' -f1 | rev | tr -d ' ' )
      PORT_PATH="/dev/$PORT_NAME"
    fi
  else
    # If nothing is provided sensei-port output is used
    PORT_PATH="$( $DIR/sensei-port | grep /dev/tty)"
    if [[ ! -z "$PORT_PATH" ]]; then
      PORT_NAME="$(echo "$PORT_PATH" | cut -d '/' -f3 )"
    else
      >&2 echo "No port provided or found."
      exit 303
    fi
  fi
fi
PORT="$PORT_PATH"
XDIR="$DEV_DIR/$PORT_NAME"
DEV_NAME="$( ls -lda $DEV_DIR/* | grep $PORT_NAME | grep '>' | cut -d ' ' -f 12  | sed 's/.*\/\(.*\)/\1/gi' )"

if [[ ! -d "$XDIR" ]]; then
  echo "# Port $PORT working dir not existing."
fi
