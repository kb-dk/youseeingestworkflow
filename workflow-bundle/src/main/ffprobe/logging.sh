#!/bin/bash

# Version 0.1.1 of the SB shell script logging framework.
#Fixed if [ -z "${*:3}" ]; then
#
# It is supposed to be sourced into you code
# It expects these variables to be set
# logFile The file to log to
# verbosity=2 The loglevel
# LOCKFILE The file to ensure that different invocations do not race the log

touch $logFile
exec 3>>$logFile

silent_lvl=0
err_lvl=1
wrn_lvl=2
inf_lvl=3
dbg_lvl=4

notify() { log $silent_lvl "NOTE:" "$@"; } # Always prints

error() { log $err_lvl "ERROR:" "$@" ; }

warn() { log $wrn_lvl "WARNING:" "$@"; }

inf() { log $inf_lvl "INFO:" "$@"; } # "info" is already a command

debug() { log $dbg_lvl "DEBUG:" "$@"; }

log() {
    (
	if [ -z "${*:3}" ]; then
		return
	fi
        flock -s 200
        if [ $verbosity -ge $1 ]; then
            # Expand escaped characters, wrap at 70 chars, indent wrapped lines
            echo -e "`date +'%b %d %H:%M:%S'`" "`hostname`" "`basename $0`[$$]" "${@:2}" | fold -w70 -s | sed '2~1s/^/  /' >&3
        fi
    ) 200>$LOCKFILE
}
