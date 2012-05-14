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
LOCALFILEURL=$2
REMOTEFILEID=$3
CHECKSUM=$4
FILESIZE=$5

LOCALNAME=`basename $LOCALFILEURL`
report "Bitrepository upload" "Starting" "Message" "$LOCALNAME"

java -cp $YOUSEE_HOME/components/bitrepoLibs/bitrepository-url-client-*:$YOUSEE_HOME/components/bitrepoLibs/* \
dk.statsbiblioteket.mediaplatform.bitrepository.urlclient.TheClient \
"$CONFIGFILE" "$LOCALFILEURL" "$REMOTEFILEID" "$CHECKSUM" "$FILESIZE"

report "Bitrepository upload" "Completed" "Message" "$LOCALNAME"