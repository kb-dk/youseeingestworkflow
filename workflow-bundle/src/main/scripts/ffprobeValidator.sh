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
XML=$2


report "FFprobe validator" "Starting" "Message" "$ENTITY"

$YOUSEE_HOME/components/profileValidator/validateXmlWithProfile.sh $XML $CONFIGFILE

report "FFprobe validator" "Completed" "Message" "$ENTITY"