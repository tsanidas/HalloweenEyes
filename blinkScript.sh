#!/bin/bash
# ########################################################################################
# Randomonly turns on then off a GPIO port to simulate blinking
# Arguments:
#    - $1: The GPIO pin, in the "Wiring Pi'" numbering scheme: https://pinout.xyz/pinout/
#          
# ########################################################################################

if [ "$1" == "" ]; then
  echo "No GPIO number provided!  Exiting"
  exit 1
fi

# VARS
GPIONUM=$1
EYES_ON_MAX=20
EYES_OFF_MAX=55

# Make sure GPIO is set to OUT
gpio mode $GPIONUM out
# Turn eyes off
gpio write $GPIONUM 0

# Blink off as eyes do
function blink() {
  # Blink once
  gpio write $GPIONUM 0
  sleep .5
  gpio write $GPIONUM 1
}

while [ true ]; do
  # Starting with eyes off to stop them from all being on for the first time
  gpio write $GPIONUM 0
  eyesoff=$RANDOM
  let "eyesoff %= $EYES_OFF_MAX"
  # Wait between turning on 
  echo "[$GPIONUM]: Eyes will turn on in $eyesoff"
  sleep $eyesoff 

  ## Random number for eyes to be on
  eyeson=$RANDOM
  let "eyeson %= $EYES_ON_MAX"
  if [ $eyeson -lt 3 ]; then
    eyeson=3
  fi
  
  gpio write $GPIONUM 1
  echo "[$GPIONUM]: Waiting for eyes to be turned off in $eyeson seconds"
  halftime=`expr $eyesoff / 2`
  if [ $halftime -gt 5 ]; then
    sleep $halftime
    blink
    sleep $halftime
  else
  	echo "[$GPIONUM]: Sleeping the full time"
  	sleep $eyeson
  fi
  gpio write $GPIONUM 0
done

# Ad infinitum
echo "exit"

