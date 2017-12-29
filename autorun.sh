#!/usr/bin/env bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

setxkbmap -layout us -variant mac
run nm-applet
run compton
run xrandr --output DVI-D-2 --mode 2560x1440 --pos 0x0 --rotate normal --output HDMI-1 --mode 2560x1440 --pos 5120x0 --rotate normal --output DP-1 --primary --mode 2560x1440 --pos 2560x0 --rotate normal --output DVI-D-1 --off
