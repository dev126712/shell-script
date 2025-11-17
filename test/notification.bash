#!/usr/bin/env bash

function send_notification() {
  brightness=$(printf "%.0f\n" $(brillo -g))
  dunstity -a "changebrightness" -u low -r 9991 -h int:value:"$brightness-$1" "Brightness: $brightness%" -t 2000
}

case $1 in
up)
  brillo -A 5 -q
  send_notification $1
  ;;
down)
  brillo -U 5 -q
  send_notification $1
  ;;
esac
