#!/bin/bash

pushd . > /dev/null
SCRIPT_PATH="${BASH_SOURCE[0]}";
if ([ -h "${SCRIPT_PATH}" ]) then
  while([ -h "${SCRIPT_PATH}" ]) do cd `dirname "$SCRIPT_PATH"`; SCRIPT_PATH=`readlink "${SCRIPT_PATH}"`; done
fi
cd `dirname ${SCRIPT_PATH}` > /dev/null
SCRIPT_PATH=`pwd`;
popd  > /dev/null

source $SCRIPT_PATH/reporterInclude.sh

CONFIGFILE=$1
XML=$2
FILEURL=$3


LOCALNAME=`basename $FILEURL`
report "FFprobe validator" "Starting" "Message" "$LOCALNAME"

$YOUSEE_HOME/components/profileValidator/validateXmlWithProfile.sh $XML $CONFIGFILE

report "FFprobe validator" "Completed" "Message" "$LOCALNAME"