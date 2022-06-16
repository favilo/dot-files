#!/usr/bin/env bash

killall -q polybar

while pgrep -x polybar >/dev/null; do sleep 1; done

if ! pgrep -x "nm-applet" >/dev/null
then
    nm-applet &
fi

if ! pgrep -x "flameshot" >/dev/null
then
  flameshot &
fi
if ! pgrep -x "blueman-applet" >/dev/null
then
  blueman-applet &
fi

if type "xrandr"; then
  for m in $(polybar --list-monitors | cut -d":" -f1); do
    declare PRIMARY=$(polybar --list-monitors | grep primary | cut -d":" -f1)
    if [[ "$m" == "$PRIMARY" ]]; then
      TRAY_POS=right MONITOR=$m polybar --reload desktop &
    else
      MONITOR=$m polybar --reload desktop &
    fi
  done
else
  polybar --reload example &
fi

echo "Bars launched..."
