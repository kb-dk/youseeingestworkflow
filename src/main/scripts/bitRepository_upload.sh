#!/bin/bash

CONFIGFILE=$1
LOCALFILEURL=$2
REMOTEFILEID=$3
CHECKSUM=$4
FILESIZE=$5


java -cp $YOUSEE_HOME/bitrepoLibs/bitrepository-url-client-*:$YOUSEE_HOME/bitrepoLibs/* \
dk.statsbiblioteket.mediaplatform.bitrepository.urlclient.TheClient \
"$CONFIGFILE" "$LOCALFILEURL" "$REMOTEFILEID" "$CHECKSUM" "$FILESIZE"
