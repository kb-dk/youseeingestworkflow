#!/bin/bash

pushd . > /dev/null
SCRIPT_PATH="${BASH_SOURCE[0]}";
if ([ -h "${SCRIPT_PATH}" ]) then
  while([ -h "${SCRIPT_PATH}" ]) do cd `dirname "$SCRIPT_PATH"`; SCRIPT_PATH=`readlink "${SCRIPT_PATH}"`; done
fi
cd `dirname ${SCRIPT_PATH}` > /dev/null
SCRIPT_PATH=`pwd`;
popd  > /dev/null

source $SCRIPT_PATH/env.sh

ENTITY=$1
RESULT=$2

if [ "$RESULT" == "true" ]; then
   report "Validation" "Validation succes" "Message" "$ENTITY"
   echo "Validated $ENTITY"
   echo "Validated $ENTITY" >&2
   exit 0
else
   report "Validation" "Validationfailure" "Message" "$ENTITY"
   echo "Failed to validate $ENTITY"
   echo "Failed to validate $ENTITY" >&2
   exit 1
fi
