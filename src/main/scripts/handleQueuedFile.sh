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

DOWNLOADER_JSON_OUTPUT=$2


source $SCRIPT_PATH/reporterInclude.sh

LOCALNAME=`cat $DOWNLOADER_JSON_OUTPUT | grep "localName" | cut -d'"' -f4`
YOUSEENAME=`cat $DOWNLOADER_JSON_OUTPUT | grep "youseeName" | cut -d'"' -f4`

report "handleQueuedfiles" "Queued" "Started with youseeFilename='$YOUSEENAME' and localname='$LOCALNAME'" "$LOCALNAME"

cat $DOWNLOADER_JSON_OUTPUT
