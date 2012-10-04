#!/bin/bash

SCRIPT_PATH=$(dirname $(readlink -f $0))




ENTITY=$1
LOCALFILEURL=$2
REMOTEFILEID=$3
CHECKSUM=$4
FILESIZE=$5

source $SCRIPT_PATH/env.sh

APPDIR="$YOUSEE_COMPONENTS/$NAME"

CMD="$JAVA_HOME/bin/java -cp $APPDIR/bin/*:$APPDIR/external-products/* \
dk.statsbiblioteket.medieplatform.bitrepository.ingester.Ingester \
$CONFIGFILE $LOCALFILEURL $REMOTEFILEID $CHECKSUM $FILESIZE"

OUTPUT="`execute "$APPDIR" "$CMD" "$NAME" "$ENTITY"`"
RETURNCODE=$?
echo "$OUTPUT"
exit "$RETURNCODE"
