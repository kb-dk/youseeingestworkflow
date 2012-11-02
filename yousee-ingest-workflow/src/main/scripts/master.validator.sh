#!/bin/bash

SCRIPT_PATH=$(dirname $(readlink -f $0))




ENTITY=$1
VALIDATIONRESULT=$2



NAME=`basename $0 .sh`

source $SCRIPT_PATH/common.sh

report "$NAME" "Started" "$ENTITY"
if [ "$VALIDATIONRESULT" == "true" ]; then
   report "$NAME" "Completed" "$ENTITY" "$NAME succeeded"
   inf "$ENTITY" "$NAME succeeded for $ENTITY"
   exit 0
else
   report "$NAME" "Failed" "$ENTITY" "$NAME failed"
   warn "$ENTITY" "$NAME failed for $ENTITY"
   exit 1
fi
