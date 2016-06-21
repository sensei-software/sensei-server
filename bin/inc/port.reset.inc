#!/bin/bash

# Sensei Port Reset
# ======================
# This file is intended to be included to reset communication on <PORT>.
# <PORT> is given as the first argument. If omitted PORT_DEFAULT is used.
# File Descriptor 7 gets closed and reopened in the process

echo "# Port reset $PORT: resetting...."

. $INC_DIR/port.close.inc $PORT
$DIR/sensei-usb-reset $PORT
$DIR/tools/ssleep $USB_AFTER_RESET_WAIT
. $INC_DIR/port.open.inc $PORT
