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
LOCALFILEURL=$2
REMOTEFILEID=$3
CHECKSUM=$4
FILESIZE=$5

report "Bitrepository upload" "Starting" "Message" "$ENTITY"

java -cp $YOUSEE_HOME/components/bitrepoLibs/bitrepository-url-client-*:$YOUSEE_HOME/components/bitrepoLibs/* \
dk.statsbiblioteket.mediaplatform.bitrepository.urlclient.TheClient \
"$CONFIGFILE" "$LOCALFILEURL" "$REMOTEFILEID" "$CHECKSUM" "$FILESIZE"

report "Bitrepository upload" "Completed" "Message" "$ENTITY"