#!/bin/bash


SCRIPT_PATH=$(dirname $(readlink -f $0))





ENTITY=$1
REMOTEURL=$2
CHANNELID=$3
STARTTIME=$4
ENDTIME=$5



NAME=`basename $0 .sh`

source $SCRIPT_PATH/common.sh

APPDIR="$YOUSEE_COMPONENTS/${yousee.digitv.ingester}/"

CMD="$JAVA_HOME/bin/java -cp $APPDIR/bin/*:$APPDIR/external-products/* \
 dk.statsbiblioteket.digitv.youseeingester.YouseeDigitvIngester \
 -filename $ENTITY \
 -starttime $STARTTIME \
 -stoptime $ENDTIME \
 -channelid $CHANNELID \
 -config $CONFIGFILE"

OUTPUT="`execute "$YOUSEE_CONFIG" "$CMD" "$NAME" "$ENTITY"`"
RETURNCODE=$?
echo "$OUTPUT"
exit "$RETURNCODE"
