#!/bin/bash

# Resizing is done using XTerm control sequences:
# https://invisible-island.net/xterm/ctlseqs/ctlseqs.html
#
# It depends on the terminal emulator if they are supported.
# This test uses a quick test by matching "xterm" from TERM
# environment variable. Does not however guarantee support. 

# Check if xterm in TERM
grep -E "xterm" <<< "$TERM" || \
    { echo "Requires xterm, or compatible. Skipping ..." && exit 2 ; }

# Create and cd to temp directory for download
[ -d tmp ] && rm -r tmp
mkdir tmp
[ ! -d tmp ] && exit 1
cd tmp || exit 1

# Save current terminal size
COLS=$(tput cols)
ROWS=$(tput lines)

# Download video in the background
youtube-dl "https://www.youtube.com/watch?v=y-E7_VHLvkE" &

# Function to check if current youtube-dl instance is still running
checkstatus () {
    # shellcheck disable=SC2009
    CHECK=$(ps -A | grep "python" | grep "youtube-dl" | awk '{print $1}')
    [ "$1" -eq "$CHECK" ] || \
        { echo "Error: youtube-dl exited unexpectedly while resizing terminal window" && \
          cleanup; \
          exit 1 ; }
}

# Resize the terminal back to it's original size, and clean any created files
cleanup() {
    SIZE='\e[8;'
    SIZE+="$ROWS;"
    SIZE+="$COLS"
    SIZE+="t"
    # shellcheck disable=SC2059
    printf "$SIZE"
    pwd | grep tmp && cd ..
    [ -d tmp ] && rm -r tmp
}

# Save the pid of the youtube-dl instance
# shellcheck disable=SC2009
PID=$(ps -A | grep "python" | grep "youtube-dl" | awk '{print $1}')

# Check if running
checkstatus "$PID"

# Resize, sleep and check status. Repeat for few times
printf '\e[8;50;100t'
sleep 2
checkstatus "$PID"
printf '\e[8;30;10t'
sleep 2
checkstatus "$PID"
printf '\e[8;10;300t'
sleep 2
checkstatus "$PID"

# Finally kill youtube-dl instance and clean
kill "$PID"
cleanup
