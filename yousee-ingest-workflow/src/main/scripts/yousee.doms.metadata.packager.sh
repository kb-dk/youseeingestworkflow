#!/bin/bash

SCRIPT_PATH=$(dirname $(readlink -f $0))




ENTITY=$1
CHECKSUM=$2
ENDTIME=$3
STARTTIME=$4
CHANNELID=$5
FORMATNAME=$6
ANNOTATION="$7"

if [ -n "$ANNOTATION" ]; then
    ANNOTATION_SWITCH="--annotation=$ANNOTATION"
fi

NAME=`basename $0 .sh`

source $SCRIPT_PATH/common.sh

APPDIR="$YOUSEE_COMPONENTS/${yousee.doms.metadata.packager}"

CMD="$JAVA_HOME/bin/java -cp $APPDIR/bin/*:$APPDIR/external-products/*:`dirname $CONFIGFILE` \
 dk.statsbiblioteket.doms.radiotv.PackageForDoms \
 --channelID=$CHANNELID \
 --format=$FORMATNAME \
 --startTime=$STARTTIME \
 --endTime=$ENDTIME \
 --recorder=yousee \
 --filename=$ENTITY \
 --checksum=$CHECKSUM \
 $ANNOTATION_SWITCH"

OUTPUT="`execute "$PWD" "$CMD" "$NAME" "$ENTITY"`"
RETURNCODE=$?
echo "$OUTPUT"
exit "$RETURNCODE"

