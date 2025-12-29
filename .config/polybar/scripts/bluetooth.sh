#!/bin/sh
if [ $(bluetoothctl show | grep "Powered: yes" | wc -l) -eq 0 ]
then
  echo "%{F#666}%{F-}"
else
  if [ $(echo info | bluetoothctl | grep 'Device' | wc -l) -eq 0 ]
  then 
    echo ""
  else
    echo "%{F#000000}%{F-}"
  fi
fi
