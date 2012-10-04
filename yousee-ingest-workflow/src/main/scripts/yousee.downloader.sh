#!/bin/bash

SCRIPT_PATH=$(dirname $(readlink -f $0))




ENTITY=$1
YOUSEENAME=$2
LOCALNAME=$3

NAME=`basename $0 .sh`

source $SCRIPT_PATH/env.sh

reportWorkflowStarted "$ENTITY"

CMD="$COMPONENT_DOWNLOADER/bin/yousee-downloader.sh $CONFIGFILE $YOUSEENAME $LOCALNAME"

OUTPUT="`execute "$PWD" "$CMD" "$NAME" "$ENTITY"`"
RETURNCODE=$?
echo "$OUTPUT"
exit "$RETURNCODE"
