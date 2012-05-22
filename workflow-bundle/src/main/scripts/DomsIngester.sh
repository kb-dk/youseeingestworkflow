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
CHECKSUM=$3
FFPROBEPROFILE_LOCATION=$4
CROSSCHECKPROFILE_LOCATION=$5
YOUSEEMETADATA_LOCATION=$6

report "Doms ingester" "Starting" "Message" "$ENTITY"

#cat $YOUSEE_HOME/examples/domsIngester_output.json
java -cp $YOUSEE_HOME/components/domsIngester/yousee-doms-ingest-client-*.jar:$YOUSEE_HOME/components/domsIngester/* \
 dk.statsbiblioteket.doms.yousee.YouseeIngesterCLI \
 -filename "$ENTITY" \
 -url "$REMOTEURL" \
 -checksum "$CHECKSUM" \
 -ffprobe "$FFPROBEPROFILE_LOCATION" \
 -crosscheck "$CROSSCHECKPROFILE_LOCATION" \
 -metadata "$YOUSEEMETADATA_LOCATION" \
# //-configFile "$CONFIGFILE"
PID=$!



report "Doms ingester" "Completed" "Message" "$ENTITY"
