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
REMOTEURL=$2
CHANNELID=$3
STARTTIME=$4
ENDTIME=$5

NAME=`basename $0 .sh`
report "$NAME" "Started" "$ENTITY"

$JAVA_HOME/bin/java -cp $YOUSEE_HOME/components/digiTVIngester/YouseeDigitvIngester-*.jar:$YOUSEE_HOME/components/digiTVIngester/* \
 dk.statsbiblioteket.digitv.youseeingester.YouseeDigitvIngester \
 -filename "$ENTITY" \
 -starttime "$STARTTIME" \
 -stoptime "$ENDTIME" \
 -channelid "$CHANNELID"
# //-configFile "$CONFIGFILE"

#cat $YOUSEE_HOME/examples/digiTVIngester_output.json

RETURNCODE=$?
if [ $RETURNCODE == 0 ];then
   report "$NAME" "Completed" "$ENTITY"
else
    report "$NAME" "Failed" "$ENTITY"
fi
exit $RETURNCODE