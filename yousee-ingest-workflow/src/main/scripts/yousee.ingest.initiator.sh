#!/bin/bash

SCRIPT_PATH=$(dirname $(readlink -f $0))


INPUT=$1

NAME=`basename $0 .sh`

source $SCRIPT_PATH/common.sh

APPDIR="$YOUSEE_COMPONENTS/${yousee.ingest.initiator}"

CMD="$JAVA_HOME/bin/java -cp $APPDIR/bin/*:$APPDIR/external-products/* \
dk.statsbiblioteket.mediaplatform.ingest.mediafilesinitiator.IngestMediaFilesInitiatorCLI $CONFIGFILE $INPUT"

OUTPUT="`execute "$YOUSEE_CONFIG" "$CMD" "$NAME"`"
RETURNCODE=$?
echo "$OUTPUT"
exit "$RETURNCODE"

