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
INPUT=$2



source $SCRIPT_PATH/reporterInclude.sh

report "ingest initiator" "Starting" "Started with input=$INPUT" "$INPUT"
#cat $YOUSEE_HOME/examples/download_initiator_output.json

java -cp $YOUSEE_HOME/components/downloadInitiatorLibs/ingest_initiator_media_files-*.jar:$YOUSEE_HOME/components/downloadInitiatorLibs/* \
dk.statsbiblioteket.mediaplatform.ingest.mediafilesinitiator.IngestMediaFilesInitiatorCLI "$CONFIGFILE" "$INPUT"

report "ingest initiator" "Completed" "Started with input=$INPUT" "$INPUT"