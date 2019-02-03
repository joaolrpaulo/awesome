#!/usr/bin/env bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

function check-enpass {
    if [[ $( ps aux | grep Enpass | grep -v grep | wc -l ) == 0 ]]; then
      run /opt/Enpass/bin/runenpass.sh
    fi
}

setxkbmap -layout us -variant mac
run nm-applet
run compton
run xautolock -time 5 -locker "dm-tool lock"
check-enpass
xrandr --output HDMI-3 --off --output HDMI-2 --off --output HDMI-1 --off --output DP-7 --off --output DP-6 --off --output DP-5 --mode 2560x1440 --pos 5120x0 --rotate normal --output DP-4 --mode 2560x1440 --pos 0x0 --rotate normal --output DP-3 --mode 2560x1440 --pos 2560x0 --rotate normal --output DP-2 --off --output DP-1 --off
