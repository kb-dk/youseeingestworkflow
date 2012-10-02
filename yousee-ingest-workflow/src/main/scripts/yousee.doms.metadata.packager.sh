#!/bin/bash

pushd . > /dev/null
SCRIPT_PATH="${BASH_SOURCE[0]}";
if ([ -h "${SCRIPT_PATH}" ]) then
  while([ -h "${SCRIPT_PATH}" ]) do cd `dirname "$SCRIPT_PATH"`; SCRIPT_PATH=`readlink "${SCRIPT_PATH}"`; done
fi
cd `dirname ${SCRIPT_PATH}` > /dev/null
SCRIPT_PATH=`pwd`;
popd  > /dev/null



ENTITY=$1
CHECKSUM=$2
ENDTIME=$3
STARTTIME=$4
CHANNELID=$5


NAME=`basename $0 .sh`

source $SCRIPT_PATH/env.sh

APPDIR="$YOUSEE_COMPONENTS/${yousee.doms.metadata.packager}"

CMD="$JAVA_HOME/bin/java -cp $APPDIR/bin/*:$APPDIR/external-products/*:`dirname $CONFIGFILE` \
 dk.statsbiblioteket.doms.radiotv.PackageForDoms \
 -channelID $CHANNELID \
 -format mpegts \
 -startTime $STARTTIME \
 -endTime $ENDTIME \
 -recorder yousee \
 -filename $ENTITY \
 -checksum $CHECKSUM \
 -muxChannelNR 3"
 #TODO channelNR not hardcoded, get from ffprobe

OUTPUT="`execute "$PWD" "$CMD" "$NAME" "$ENTITY"`"
RETURNCODE=$?
echo "$OUTPUT"
exit "$RETURNCODE"

