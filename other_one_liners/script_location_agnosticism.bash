#!/bin/bash

# Common issue I've had when chaining scripts together is when using relative
# locations the script assumes your working directory is the one you are in
# when you initially fire the script
# So if you're in `/home/user/` and run `bash /tmp/script.bash`, your CWD is
# `/home/user` according to the script.  This causes issues when you need to
# access other files/scripts in the same directory.

# Usage:
# Change:
#   From: "./some_other_script.bash"
#   To:   "${SCRIPT_DIR}/some_other_script.bash"


# Get script directory
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  SCRIPT_DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$SCRIPT_DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SCRIPT_DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
