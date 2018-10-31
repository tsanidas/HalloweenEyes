#!/bin/bash
# ########################################################################################
# blinkDriver.sh
#   Script to read list of GPIO ports and kick off a random blinking script for each one.
#   Requires a config file location passed in as the first argument.  See "eyes.conf" for
#   a config file example and explanation of variables within the config file.
#
# Tom Sanidas
# ########################################################################################
if [ "$1" == "" ]; then
  echo "No GPIO ports file provided!  Exiting"
  exit 1
fi

if [ ! -f "$1" ]; then
  echo "GPIO ports file does not exist or cannot be read!  Exiting"
  exit 2
fi

# VARS
. $1
# GPIONUMS, PWMNUMS, TESTSECONDS loaded

if [ "${GPIONUMS}" == "" ]; then
  echo "GPIO ports file does not contain a setting named GPIONUMS.  Exiting"
  exit 3
fi

if [ "${PWMNUMS}" == "" ]; then
  echo "No PWM gpio ports were specified. (Not a problem)"
fi

#EYES_ON_MAX=20
#EYES_OFF_MAX=55

# Startup test: Set each one on for 5 seconds
for GPIONUM in $GPIONUMS; do
  # Make sure GPIO is set to OUT
  gpio mode $GPIONUM out
  # Turn eye pair on 
  echo "Testing [$GPIONUM] for $TESTSECONDS seconds"
  gpio write $GPIONUM 1  
  # Wait
  sleep $TESTSECONDS
  # Turn off
  echo "[$GPIONUM] test complete"
  gpio write $GPIONUM 0
done

for PWMNUM in $PWMNUMS; do
  # Set GPIO to PWM
  gpio mode $PWMNUM pwm
  echo "Testing [$PWMNUM] for $TESTSECONDS seconds"
  gpio pwm $PWMNUM 1000
  # Wait
  sleep $TESTSECONDS
  # Turn off
  echo "[$PWMNUM] test complete"
  gpio pwm $PWMNUM 0
done

for GPION in $GPIONUMS; do
  # Spawn a process for each eye thingey
  ./blinkScript.sh $GPION &
done

for PWMNUM in $PWMNUMS; do
  # Spawn a different script to blink the PWM ports if any
  ./pwmBlink.sh $PWMNUM &
done

# Wait on children to exit so that we stay alive
while [ true ]; do
  wait 
done

sleep 3
echo "$0 exit"

