#!/bin/bash
echo "{" | $DIR/tools/ts "$COMMAND_LINE_FORMAT"| tee -a
echo "REL_$rel_option COMMAND received. Switching to REL_SAFE MODE." | $DIR/tools/ts "   $COMMAND_LINE_FORMAT"| tee -a $XDIR/sensei_commands.log
{
  rel_n=$(echo "$line" | cut -d ' ' -f2 | grep -E -o "[0-9]")
} || {
  rel_n=""
}
if [[ -z "$rel_n" ]]; then
  echo "REL_$rel_option COMMAND was GLOBAL. Switching to NORMAL MODE." | $DIR/tools/ts "   $COMMAND_LINE_FORMAT"| tee -a $XDIR/sensei_commands.log
  echo "$line">&7
  timeout $COMMAND_RESPONSE_TIMEOUT cat <&7 | $DIR/tools/ts "   $COMMAND_LINE_FORMAT"| tee -a $XDIR/sensei_commands.log
  echo "REL_STATUS">&7
  timeout $COMMAND_RESPONSE_TIMEOUT cat <&7 | $DIR/tools/ts "   $COMMAND_LINE_FORMAT"| tee
  continue
fi

if [ "$rel_option" = "ON" ]; then
  rel_new_status="1"
  rel_status="0"
else
  rel_new_status="0"
  rel_status="1"
fi
rel_safe_attempts=0;

until [ "$rel_status" = "$rel_new_status" ]; do
  rel_safe_attempts=$((rel_safe_attempts+1));
  echo -e "REL_STATUS $rel_n\n">&7
  rel_status=$(timeout $LONG_COMMAND_RESPONSE_TIMEOUT cat <&7 | grep "(R$rel_n)" | cut -d '=' -f2 | grep -E -o "[-01]+" | head -n1)
  if [[ "$rel_status" = "-1" ]]; then
    rel_status=""
  fi
  if [[ -z "$rel_status" ]]; then
    >&2 echo "REL_SAFE: WARNING REL_STATUS not received"
  fi
  echo "REL_STATUS (R$rel_n) [REL_SAFE] {/} = $rel_status" | $DIR/tools/ts "   $COMMAND_LINE_FORMAT"| tee -a $XDIR/sensei_commands.log
  if [[ -z "$rel_status" && $rel_safe_attempts -ge $REL_SAFE_ATTEMPTS_RESET ]]; then
    >&2 echo "REL_SAFE: WARNING ERROR retrieving status of R$rel_n after $rel_safe_attempts attempts. Retrying (reset).."
    . $INC_DIR/port.reset.inc $PORT
    rel_safe_attempts=0
  else
    if [ "$rel_status" = "$rel_new_status" ]; then
      echo "REL_SAFE: R$rel_n IS $rel_option" | $DIR/tools/ts "   $COMMAND_LINE_FORMAT"| tee -a $XDIR/sensei_commands.log
      echo "}" | $DIR/tools/ts "$COMMAND_LINE_FORMAT"| tee -a $XDIR/sensei_commands.log
    else
      echo "REL_SAFE: BRINGING $rel_option R$rel_n ($rel_safe_attempts attempt)..." | $DIR/tools/ts "   $COMMAND_LINE_FORMAT"| tee -a $XDIR/sensei_commands.log
      echo -e "REL_$rel_option $rel_n\n">&7
      sleep $COMMAND_RESPONSE_TIMEOUT
    fi
  fi
done
