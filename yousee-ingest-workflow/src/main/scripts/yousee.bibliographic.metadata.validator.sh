#!/bin/bash

SCRIPT_PATH=$(dirname $(readlink -f $0))

ENTITY=$1
LOCALFILEURL=$2
CHANNELID=$3
STARTTIME=$4
ENDTIME=$5
FFPROBE=$6
CROSSCHECK=$7

NAME=`basename $0 .sh`

source $SCRIPT_PATH/common.sh

APPDIR="$YOUSEE_COMPONENTS/${yousee.bibliographic.metadata.validator}"

source $CONFIGFILE

CMD="$JAVA_HOME/bin/java -cp $APPDIR/bin/*:$APPDIR/external-products/*:`dirname $CONFIGFILE` \
  dk.statsbiblioteket.medieplatform.bibliographicValidator.BibliographicCLI \
 --channelID=$CHANNELID \
 --startTime=$STARTTIME \
 --endTime=$ENDTIME \
 --fluff=$FLUFF \
 --ffprobe=$FFPROBE \
 --crosscheck=$CROSSCHECK "


#CMD="cat $YOUSEE_HOME/examples/bibliograpthic_validator_output.json"
#CMD="echo {\"valid\":true}"

#extract duration as number
#extract duration from startTime and endTime
#compare fuzzy

OUTPUT="`execute "$PWD" "$CMD" "$NAME" "$ENTITY"`"
RETURNCODE=$?
echo "$OUTPUT"
exit "$RETURNCODE"

