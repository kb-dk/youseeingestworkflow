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


APPDIR="$YOUSEE_COMPONENTS/Ingest_Initiator"

CMD="$JAVA_HOME/bin/java -cp $APPDIR/bin/*:$APPDIR/external-products/* \
dk.statsbiblioteket.mediaplatform.ingest.mediafilesinitiator.IngestMediaFilesInitiatorCLI $CONFIGFILE $INPUT"

OUTPUT="`execute "$YOUSEE_CONFIG" "$CMD" "$NAME"`"
RETURNCODE=$?
echo "$OUTPUT"
exit "$RETURNCODE"

