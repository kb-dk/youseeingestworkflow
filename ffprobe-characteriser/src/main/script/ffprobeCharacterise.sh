#!/bin/bash

FILENAME=$1
CONFIG=$2


pushd . > /dev/null
SCRIPT_PATH="${BASH_SOURCE[0]}";
if ([ -h "${SCRIPT_PATH}" ]) then
  while([ -h "${SCRIPT_PATH}" ]) do cd `dirname "$SCRIPT_PATH"`; SCRIPT_PATH=`readlink "${SCRIPT_PATH}"`; done
fi
cd `dirname ${SCRIPT_PATH}` > /dev/null
SCRIPT_PATH=`pwd`;
popd  > /dev/null

if [ -z $YOUSEE_HOME ]; then
    YOUSEE_HOME=$SCRIPT_PATH/unittest
fi

source $CONFIG

source $SCRIPT_PATH/logging.sh


#std error to log
#std out as return value


tempfile="`mktemp`"

#echo $tempfile
OUTPUT="`ffprobe -noprivate -show_format -show_streams -print_format xml=x=1 -i $FILENAME 2> "$tempfile"`"

RETURNCODE="$?"

#echo $OUTPUT
#cat $tempfile

if [ "$RETURNCODE" -eq "0" ]; then
    debug "Characterised file $FILENAME \n `cat $tempfile`"
    rm "$tempfile"
    echo "$OUTPUT"
    exit "0"
else
    error "Failed for file $FILENAME \n `cat $tempfile`"
    rm "$tempfile"
    error "Failed for file $FILENAME \n $OUTPUT"
    exit "$RETURNCODE"
fi

