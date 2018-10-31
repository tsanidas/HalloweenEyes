#!/bin/bash 
# ########################################################################################
# 
# Gradually turn on off eyes, with random pause between to keep eyes open
# ONLY works for PWM ports
# 
# ########################################################################################

if [ "$1" == "" ]; then
  echo "Usage: $0 <pwm gpio number>"
  exit 2
fi

# VARS
THISPWM=$1
EYES_ON_MAX=20
EYES_OFF_MAX=55

# Slowly open eyes
function openEyes() {
  COUNTER=0
  while [  $COUNTER -lt 1020 ]; do
    let COUNTER=COUNTER+20
    sleep .2
    gpio pwm $THISPWM $COUNTER
  done
}

# Slowly close eyes
function closeEyes() {
  COUNTER=1020
  while [  $COUNTER -gt 20 ]; do
    let COUNTER=COUNTER-20
    sleep .2
    gpio pwm $THISPWM $COUNTER
  done
  sleep 1
  gpio pwm $THISPWM 0
}

# Blink off as eyes do
function blink() {
  # Blink once
  gpio pwm $THISPWM 0
  sleep .5
  gpio pwm $THISPWM 1020
}

# Set mode to pwm
gpio mode $THISPWM pwm

while [ true ]; do
  gpio pwm $THISPWM 0

  eyesoff=$RANDOM
  let "eyesoff %= $EYES_OFF_MAX"
  # Wait between turning on 
  echo "[$THISPWM]/(PWM): Eyes will turn on in $eyesoff"
  sleep $eyesoff 

  ## Random number for eyes to be on
  eyeson=$RANDOM
  let "eyeson %= $EYES_ON_MAX"

  openEyes
  blink
  echo "[$THISPWM]/(PWM): Waiting for eyes to be turned off in $eyeson seconds"
  sleep $eyeson

  closeEyes
done

# Ad infinitum
echo "exit"

