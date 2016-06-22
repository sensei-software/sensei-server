#!/bin/bash
GET_cache_time=0
lines_to_watch=100
if [[ ! -f $XDIR/sensei_commands.log ]]; then
	>$XDIR/sensei_commands.log
fi
last_line=$(tail -n $lines_to_watch $XDIR/sensei_commands.log | grep "GET =" | tail -n 1)
last_val=$( echo "$last_line" | cut -d '=' -f 3 | tr -d " :blank:\n\r")
last_val_d=$( echo "$last_line" | cut -d '=' -f 1 | sed s/\s$// )
#echo -e $last_line
if date -d "$last_val_d" >/dev/null; then last_val_s=$(date -d "$last_val_d" '+%s'); else last_val_s="$last_val_s"; fi
now_s=$(date '+%s')
elapsed=$(( $now_s-$last_val_s ))

if [ $elapsed -ge $GET_cache_time ]; then
  echo "GET sending $elapsed $last_val_s"
	echo "$line" >&7
	resp="$(timeout $COMMAND_RESPONSE_TIMEOUT cat <&7)"
	while read resp_line; do
		measure="<$DEV_NAME> $(echo $resp_line | sed 's/\(.*\) =.*/\1/gi' )"
		value="$(echo $resp_line | sed 's/.*= \(.*\)/\1/gi' )"
		$DIR/sensei-track-value \"$measure\" \"$value\"
		echo "$resp_line" | $DIR/tools/ts "$COMMAND_LINE_FORMAT"| tee -a $XDIR/sensei_commands.log
	done <<< "$resp"
else
  echo "GET ignored $elapsed  $last_val_s"
fi
