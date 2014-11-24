#!/bin/sh

if [ -e /proc/driver/nvidia/version ]; then
  make nvidia
else
  make mesa
fi
