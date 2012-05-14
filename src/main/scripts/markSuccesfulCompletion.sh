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
DOMSPID=$2
DIGITVPID=$3
REMOTEURL=$4
LOCALURL=$5


LOCALNAME=`basename $LOCALURL`
report "Yousee complete workflow final step" "Starting" "Message" "$LOCALNAME"


echo $DOMSPID
echo $DIGITVPID
echo $REMOTEURL
echo $LOCALURL

report "Yousee complete workflow final step" "Completed" "Message" "$LOCALNAME"

#TODO rm the downloaded file