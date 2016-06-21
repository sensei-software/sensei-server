#!/bin/bash

# -h hook
for var in "$@"
do
  if [ "$var" == "-h" ]; then
		grep "#?" $0
		exit 0
	fi
done

# Standard settings
IFS=$'\n'
