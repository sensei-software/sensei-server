#!/bin/bash
DIR="/home/sensei/sensei-server/bin"

resp="$(curl -s 'http://api.apixu.com/v1/current.json?key=164401c7fc014b9cb3f211540160409&q=Palermo' )"

name="<Weather> TEMPERATURE (apixu) [] {C}"
val="$(echo \"$resp\" | grep -Po '(?<=\"temp_c\":)[^,]+')"
$DIR/sensei-track-value "$name" "$val"

name="<Weather> HUMIDITY (apixu) [] {%}"
val="$(echo \"$resp\" | grep -Po '(?<=\"humidity\":)[^,]+')"
$DIR/sensei-track-value "$name" "$val"

name="<Weather> IS_DAY (apixu) [] {/}"
val="$(echo \"$resp\" | grep -Po '(?<=\"is_day\":)[^,]+')"
$DIR/sensei-track-value "$name" "$val"
