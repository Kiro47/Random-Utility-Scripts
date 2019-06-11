#!/bin/bash

if [ -z "$1" ]; then
  echo "Syntax : $0 <file to strip>"
  echo "Strips lines beggining with #, not inline support"
  exit 0
fi
if [ -d "$1" ]; then
  echo "$1 is directory, exiting..."
  exit -2
fi
if [ -f  "$1" ]; then
  # do the thing
  cat <(sed '/^[[:blank:]]*#/d;/^$/d' "$1")
else
  echo "$1 does not exist!"
  exit -1
fi
