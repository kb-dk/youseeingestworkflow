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

INPUT=$1

NAME=`basename $0 .sh`
report "$NAME" "Starting" "Started with input=$INPUT" "$INPUT"

#cat $YOUSEE_HOME/examples/download_initiator_output.json
java -cp $YOUSEE_HOME/components/downloadInitiatorLibs/ingest_initiator_media_files-*.jar:$YOUSEE_HOME/components/downloadInitiatorLibs/* \
dk.statsbiblioteket.mediaplatform.ingest.mediafilesinitiator.IngestMediaFilesInitiatorCLI "$CONFIGFILE" "$INPUT"

report "$NAME" "Completed" "Started with input=$INPUT" "$INPUT"