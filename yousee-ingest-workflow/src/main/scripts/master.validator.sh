#!/bin/bash

pushd . > /dev/null
SCRIPT_PATH="${BASH_SOURCE[0]}";
if ([ -h "${SCRIPT_PATH}" ]) then
  while([ -h "${SCRIPT_PATH}" ]) do cd `dirname "$SCRIPT_PATH"`; SCRIPT_PATH=`readlink "${SCRIPT_PATH}"`; done
fi
cd `dirname ${SCRIPT_PATH}` > /dev/null
SCRIPT_PATH=`pwd`;
popd  > /dev/null



ENTITY=$1
VALIDATIONRESULT=$2



NAME=`basename $0 .sh`

source $SCRIPT_PATH/env.sh

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
