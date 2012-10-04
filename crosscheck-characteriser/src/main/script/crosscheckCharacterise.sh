#!/bin/bash

FILEURL="$1"
CONFIG="$2"

SCRIPT_PATH=$(dirname $(readlink -f $0))

if [ -z $YOUSEE_HOME ]; then
    YOUSEE_HOME=$SCRIPT_PATH/unittest
fi

source "$CONFIG"

source "$SCRIPT_PATH/logging.sh"


#std error to log
#std out as return value


tempfile="`mktemp`"

#echo $tempfile

FILENAME="${FILEURL#"file://"}"

OUTPUT="`ssh $HOST crosscheck  -a 0 -f x $FILENAME 2> "$tempfile"`"
RETURNCODE="$?"

#echo $OUTPUT
#cat $tempfile

if [ "$RETURNCODE" -lt "3" ]; then
    debug "Characterised file $FILEURL \n `cat $tempfile`"
    rm "$tempfile"
    echo "$OUTPUT"
    exit "0"
else
    error "Failed for file $FILEURL \n `cat $tempfile`"
    rm "$tempfile"
    error "Failed for file $FILEURL \n $OUTPUT"
    exit "$RETURNCODE"
fi


