#!/bin/bash

# Sensei Port Open
# ======================
# This file is intended to be included to init communication on <PORT>.
# <PORT> is given as the first argument. If omitted PORT_DEFAULT is used.
# File Descriptor 7 is opened and available as communication interface.

# Port path check
if [[ ! -e "$PORT" ]]; then
	>&2 echo "ERROR port $PORT not connected."
	exit 300
fi

# Device main directory check
if [[ ! -d "$DEV_DIR" ]]; then
	echo "DEV_DIR ($DEV_DIR) missing, creating.."
	mkdir "$DEV_DIR"
fi
# Device specific directory check
if [[ ! -d "$XDIR" ]]; then
	echo "# Port $PORT WorkingDir: Creating device dir $XDIR"
	mkdir $XDIR
	cp $RES_DIR/dev_dir_tpl/* $XDIR/
else
	echo "# Port $PORT WorkingDir: Found device dir $XDIR"
fi

# Communication init
#stty -F $PORT sane cs8 speed $BAUD_DEFAULT -hupcl raw -echo > /dev/null
stty -F $PORT sane cs8 speed $BAUD_DEFAULT hupcl raw -echo > /dev/null
exec 7<>$PORT || {
	>&2 echo "ERROR opening port $PORT (error $?)"
	exit 1
}
echo "# Port $PORT Setup: succesfully initialized tty communication ($BAUD_DEFAULT)."
if [[ ! -z "$PORT_RAW_OPEN" ]]; then
	echo "# Port $PORT RawOpen: OK";
else
	echo "# Port $PORT Waiting: for WELCOME MSG."
	welcomeMsg=$(timeout $WELCOME_MSG_BOOT_WAIT cat<&7 | grep "#")
	# Check WLC_MSG
	if [[ ! "$welcomeMsg" = *[!\ \n]* ]]; then
			>&1 echo "# Port $PORT WARNING: (0216) got no welcome message on Connect. Waiting $WELCOME_MSG_REQ_WAIT s"
			$DIR/tools/ssleep $WELCOME_MSG_REQ_WAIT
			# Try to request WLC_MSG
			echo "WLC_MSG">&7
			welcomeMsg=$(timeout $LONG_COMMAND_RESPONSE_TIMEOUT cat<&7 | grep "#")
			if [[ ! "$welcomeMsg" = *[!\ \n]* ]]; then
				if [[ -z "$WELCOME_MSG_DEFAULT" ]]; then
					>&2 echo "# Port $PORT ERROR: (0206) got no welcome message on Request ($welcomeMsg)."
				else
					echo "# Port $PORT INFO: got no welcome message on Connect. Using default."
					welcomeMsg="$WELCOME_MSG_DEFAULT"
				fi
			else
				echo "# Port $PORT WelcomeMsg: (OK) on Request"
			fi
	else
		echo "# Port $PORT WelcomeMsg: (OK) on Connect"
	fi

	echo -e "$welcomeMsg" | $DIR/tools/ts "$PORT_NAME>"
	devId=$( echo -e "$welcomeMsg" | grep -P "(?<=DEV: )[^\s]+(?=\s)" -o -m 1)
	devName=$( echo -e "$welcomeMsg" | grep -P "(?<=SID: )[^\s]+(?=\s)" -o -m 1)
	if [[ -z "$devId" ]]; then
		>&2 echo "# Port $PORT ERROR: (0207) no DEV_ID on welcome message."
		exit 1
	else
		if [[ -z "$devName" ]]; then
			>&2 echo "# Port $PORT WARNING: (0218) no DEV_NAME on welcome message."
		fi
		echo "# Port $PORT DevId: (OK) $devId '$devName'"
	fi

fi

DEV_ID="$devId"
DEV_NAME="$devName"

#TODO: manage here "?" command list
