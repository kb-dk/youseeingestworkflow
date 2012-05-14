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
report "Crosscheck Validator" "Starting" "Message" "$LOCALNAME"


$YOUSEE_HOME/components/profileValidator/validateXmlWithProfile.sh $XML $CONFIGFILE

report "Crosscheck Validator" "Completed" "Message" "$LOCALNAME"