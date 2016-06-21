#!/bin/bash

# Sensei Port Close
# ======================
# This file is intended to be included to close communication on <PORT>.
# <PORT> is given as the first argument. If omitted PORT_DEFAULT is used.
# File Descriptor 7 gets closed in the process

echo "# Port close $PORT: closing...."

# Device directory check
if [[ ! -d "$XDIR" ]]; then
	echo "# ERROR no device dir $XDIR" >&2
else
	echo "# Found device dir $XDIR"
fi

exec 7<&-
stty -F $PORT sane
echo "# Port close $PORT: succesfully CLOSED."
