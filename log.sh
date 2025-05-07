#!/bin/bash

# Provides info, warn, error, and die funtions for scripts. Add by sourcing this script.
# source "$(dirname $0)/log.sh"

# Test functions by running directly, then with pipe
# ./log.sh
# ./log.sh | cat -

# Description: outputs the text with the terminal color code specified if
#              this is an interactive terminal.
# $1 - message
# $2 - color code

# This needs to be overridden after log.sh is sourced to disable output when script is run in non-terminal
NO_OUT_NON_TERM=""

LOG_LEVEL=${LOG_LEVEL:-4}
[[ $LOG_LEVEL == NONE ]] && LOG_LEVEL=0
[[ $LOG_LEVEL == FATAL ]] && LOG_LEVEL=1
[[ $LOG_LEVEL == ERROR ]] && LOG_LEVEL=2
[[ $LOG_LEVEL == WARN ]] && LOG_LEVEL=3
[[ $LOG_LEVEL == INFO ]] && LOG_LEVEL=4
[[ $LOG_LEVEL == DEBUG ]] && LOG_LEVEL=5
[[ $LOG_LEVEL == TRACE ]] && LOG_LEVEL=6
if [[ ! $LOG_LEVEL =~ ^[0-6]$ ]]; then
    echo "Invalid LOG_LEVEL specified using INFO(4)"
    LOG_LEVEL=4
fi

show() {
    TS=$(date --rfc-3339=seconds)
    if [[ -t 1 ]]; then
        # Coloring is ok
        printf -- "\x1b[$2m$1\x1b[m\n"
    elif [[ -z $NO_OUT_NON_TERM ]]; then
        printf -- "$1\n"
    fi
    if [[ -n $LOGFILE && -w $LOGFILE ]]; then
        printf -- "$TS $1\n" >> $LOGFILE
    fi
}

fatal() {
    if [[ $LOG_LEVEL -ge 1 ]]; then
        show "FATAL: $1" 31; # 31 is red
    fi
}
error() {
    if [[ $LOG_LEVEL -ge 2 ]]; then
        show "ERROR: $1" 31; # 31 is red
    fi
}
warn()  {
    if [[ $LOG_LEVEL -ge 3 ]]; then
        show "WARN: $1" 33; # 33 is yellow
    fi
}
info()  {
    if [[ $LOG_LEVEL -ge 4 ]]; then
        show "INFO: $1" 34; # 34 is blue
    fi
}
debug() {
    if [[ $LOG_LEVEL -ge 5 ]]; then
        show "DEBUG: $1" 35;
    fi
}
trace() {
    if [[ $LOG_LEVEL -ge 6 ]]; then
        show "TRACE: $1" 36;
    fi
}
# Outputs the first parameter and terminates with exit 1
die() {
    fatal "$1"
    exit 1
}

heading() {
    msg="$1"
    echo
    show "$1" 35
    show "$(echo "$1" | sed 's/./=/g')" 35
}

# Initialize LOGFILE
if [[ -n $LOGFILE ]]; then
    if [[ ! -e $LOGFILE ]]; then
        if ! touch $LOGFILE; then
            LOGFILE="" die "Error creating $LOGFILE"
        fi
    elif [[ ! -w $LOGFILE ]]; then
        LOGFILE="" die "Can not write to $LOGFILE"
    fi
fi

# Test
if [[ "$0" =~ .*log.sh ]]; then
    info "Info Test"
    warn "Warn Test"
    error "Error Test"
    die "Fatal error"
    echo "Should not get here"
fi
