#!/bin/bash

CONFIGFILE=$1
INPUT=$2

java -cp $YOUSEE_HOME/components/downloadInitiatorLibs/ingest_initiator_media_files-*.jar:$YOUSEE_HOME/components/downloadInitiatorLibs/* \
dk.statsbiblioteket.mediaplatform.ingest.ingestinitiatormediafiles.IngestInitiatorMediaFilesCLI "$CONFIGFILE" "$INPUT"