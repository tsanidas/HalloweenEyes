#!/bin/bash
#
# blinkShutdown.sh
#   When the service is stopped, sets all the ports to off
#   Requires a config file in the format of:
#   GPIONUMS="x y z"
#
# VERSION 1.0
#
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


# Shutdown: Make sure all are set off
for GPIONUM in $GPIONUMS; do
  # Make sure GPIO is set to OUT
  gpio mode $GPIONUM out
  # Turn eye pair off
  echo "Shutdown: shutting off [$GPIONUM]"
  gpio write $GPIONUM 0  
done

for PWMNUM in $PWMNUMS; do
  # Turn off
  echo "Shutdown: shutting off [$PWMNUM]/(PWM)"
  gpio pwm $PWMNUM 0
done


echo "$0 exit"

