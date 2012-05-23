#!/bin/bash

FILENAME=$1
CONFIG=$2

source $CONFIG

pushd . > /dev/null
SCRIPT_PATH="${BASH_SOURCE[0]}";
if ([ -h "${SCRIPT_PATH}" ]) then
  while([ -h "${SCRIPT_PATH}" ]) do cd `dirname "$SCRIPT_PATH"`; SCRIPT_PATH=`readlink "${SCRIPT_PATH}"`; done
fi
cd `dirname ${SCRIPT_PATH}` > /dev/null
SCRIPT_PATH=`pwd`;
popd  > /dev/null

source $SCRIPT_PATH/logging.sh

#std error to log
#std out as return value


tempfile=`mktemp`

OUTPUT=`ffprobe -noprivate -show_format -show_streams -print_format xml=x=1 -i $FILENAME 2>$tempfile`
RETURNCODE=$?

if [ "$RETURNCODE" == 0 ]; then
    debug `cat $tempfile`
    rm $tempfile
    echo $OUTPUT
    exit 0
else
    error `cat $tempfile`
    rm $tempfile
    error $OUTPUT
    exit $RETURNCODE
fi


