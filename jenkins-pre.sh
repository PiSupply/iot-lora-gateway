#!/bin/sh
osPlatform=`uname -m`

if [ "$osPlatform"=="x86_64" ]; then
  echo "This is a x86 system";
  exit 1
fi

#Platform should be Raspberry Pi
