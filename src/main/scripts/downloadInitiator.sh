#!/bin/bash

CONFIGFILE=$1
INPUT=$2


#cat $YOUSEE_HOME/examples/download_initiator_output.json

java -cp $YOUSEE_HOME/components/downloadInitiatorLibs/ingest_initiator_media_files-*.jar:$YOUSEE_HOME/components/downloadInitiatorLibs/* \
dk.statsbiblioteket.mediaplatform.ingest.ingestinitiatormediafiles.IngestInitiatorMediaFilesCLI "$CONFIGFILE" "$INPUT"