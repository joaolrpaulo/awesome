#!/usr/bin/env bash

## run (only once) processes which spawn with the same name
function run {
   if (command -v $1 && ! pgrep $1); then
     $@&
   fi
}

function check-enpass {
    if [[ $( ps aux | grep Enpass | grep -v grep | wc -l ) == 0 ]]; then
      run /opt/enpass/Enpass
    fi
}

# Boot every daemon
run nm-applet
run compton --shadow-exclude '!focused'
run xautolock -time 5 -locker "dm-tool lock"
run thunar --daemon
run blueman-applet
run msm_notifier

# Boot Enpass
check-enpass

# Set the keyoard layout
setxkbmap -layout us -variant mac