#!/bin/bash

SCRIPT_PATH=$(dirname $(readlink -f $0))




ENTITY=$1
LOCALFILEURL=$2
CHANNELID=$3
STARTTIME=$4
ENDTIME=$5


NAME=`basename $0 .sh`

source $SCRIPT_PATH/env.sh

#CMD="cat $YOUSEE_HOME/examples/bibliograpthic_validator_output.json"
CMD="echo {\"valid\":true}"

OUTPUT="`execute "$PWD" "$CMD" "$NAME" "$ENTITY"`"
RETURNCODE=$?
echo "$OUTPUT"
exit "$RETURNCODE"

