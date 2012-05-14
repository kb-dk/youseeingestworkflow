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
REMOTEURL=$2
CHANNELID=$3
STARTTIME=$4
ENDTIME=$5

LOCALNAME=`basename $REMOTEURL`
report "Digitv ingest" "Starting" "Message" "$LOCALNAME"

cat $YOUSEE_HOME/examples/digiTVIngester_output.json

report "Digitv ingest" "Completed" "Message" "$LOCALNAME"