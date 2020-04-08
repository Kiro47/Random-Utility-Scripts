#!/bin/bash
while getopts ":h" opt;
do
  case ${opt} in
    h )
      echo "scriptname video_file maximum_file_size_in_mb"
      exit 0
      ;;
  esac
done
bitrate="$(awk "BEGIN {print int($2 * 1024 * 1024 * 8 / $(ffprobe \
    -v error \
    -show_entries format=duration \
    -of default=noprint_wrappers=1:nokey=1 \
    "$1" \
) / 1000)}")k"
ffmpeg \
    -y \
    -i "$1" \
    -c:v libx264 \
    -preset medium \
    -b:v $bitrate \
    -pass 1 \
    -an \
    -f mp4 \
    /dev/null \
&& \
ffmpeg \
    -i "$1" \
    -c:v libx264 \
    -preset medium \
    -b:v $bitrate \
    -pass 2 \
    -an \
    "${1%.*}-$2mB.mp4"
