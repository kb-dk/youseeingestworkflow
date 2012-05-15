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
REMOTEURL=$2
CHANNELID=$3
STARTTIME=$4
ENDTIME=$5

report "Digitv ingest" "Starting" "Message" "$ENTITY"

cat $YOUSEE_HOME/examples/digiTVIngester_output.json

report "Digitv ingest" "Completed" "Message" "$ENTITY"