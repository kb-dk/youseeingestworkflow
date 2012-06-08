#!/bin/bash

# Version 0.1.1 of the SB shell script logging framework.
#Fixed if [ -z "${*:3}" ]; then
#
# It is supposed to be sourced into you code
# It expects these variables to be set
# logFile The file to log to
# verbosity=2 The loglevel
# LOCKFILE The file to ensure that different invocations do not race the log


silent_lvl=0
err_lvl=1
wrn_lvl=2
inf_lvl=3
dbg_lvl=4

notify() { log $1 $silent_lvl "NOTE:" "${@:2}"; } # Always prints

error() { log $1 $err_lvl "ERROR:" "${@:2}" ; }

warn() { log $1 $wrn_lvl "WARNING:" "${@:2}"; }

inf() { log $1 $inf_lvl "INFO:" "${@:2}"; } # "info" is already a command

debug() { log $1 $dbg_lvl "DEBUG:" "${@:2}"; }

log() {
    (
	if [ -z "${*:4}" ]; then
		return
	fi
        flock -s 200
        if [ $verbosity -ge $2 ]; then
            # Expand escaped characters, wrap at 70 chars, indent wrapped lines
            echo -e "`date +'%b %d %H:%M:%S'`" "`hostname`" "`basename $0`[$$]" "${@:3}" | fold -w70 -s | sed '2~1s/^/  /' >> $LOGDIR/$1.log
        fi
    ) 200>$LOCKFILE
}
