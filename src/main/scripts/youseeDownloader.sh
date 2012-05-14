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
YOUSEENAME=$2
LOCALNAME=$3

report "yousee Downloader" "Starting" "Started with youseeFilename='$YOUSEENAME' and localname='$LOCALNAME'" "$LOCALNAME"

#cat $YOUSEE_HOME/examples/downloader_output_downloaded.json
$YOUSEE_HOME/components/youseeDownloader/yousee-downloader.sh "$CONFIGFILE" "$YOUSEENAME" "$LOCALNAME"

report "yousee Downloader" "completed" "Started with youseeFilename='$YOUSEENAME' and localname='$LOCALNAME'" "$LOCALNAME"