#!/bin/bash

# Extracts the files into your current directory
# Probably could abstract this for the better, but it was faster to copy and
# paste

# Suports a few of my most commonly used parrell compressors
# also helps me not need to remember dumb syntax differences

IN_tar_bz2()
{
  # Check for parrallel decompressor
	which lbzip2 > /dev/null
  ret="$?"
  if [ "$ret" -eq 0 ]; then
    tar --use-compress-program=lbzip2 -xf "$1"
  else
    tar -xjf "$1"
  fi
}

IN_bzip2()
{
  # Check for parrallel decompressor
	which lbzip2 > /dev/null
  ret="$?"
  if [ "$ret" -eq 0 ]; then
    bzip2 -kd "$1"
  else
    lbzip2 -kd "$1"
  fi
}

IN_tar_gz()
{
  # Check for parrallel decompressor
	which pigz > /dev/null
  ret="$?"
  if [ "$ret" -eq 0 ]; then
    tar --use-compress-program=pigz -xf "$1"
  else
    tar -xzf "$1"
  fi
}

IN_gzip()
{
  # Check for parrallel decompressor
	which pigz > /dev/null
  ret="$?"
  if [ "$ret" -eq 0 ]; then
    pigz -kd "$1"
  else
    gunzip "$1"
  fi
}

main()
{
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2)   IN_tar_bz2 "$1"      ;;
      *.tar.gz)    IN_tar_gz "$1"    ;;
      *.bz2)       IN_bzip2 "$1"     ;;
      *.rar)       unrar -x "$1"     ;;
      *.gz)        IN_gzip "$1"      ;;
      *.tar)       tar -xf "$1"     ;;
      *.tbz2)      tar -xjf "$1"    ;;
      *.tgz)       tar -xzf "$1"    ;;
      *.zip)       unzip "$1"       ;;
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z -x "$1"        ;;
      *)           echo "Unknown compression type '$1'..." ;;
    esac
  fi
}

main "$@"
