#!/bin/bash

CONFIGFILE=$1
YOUSEENAME=$2
LOCALNAME=$3

#cat $YOUSEE_HOME/examples/downloader_output_downloaded.json
$YOUSEE_HOME/components/youseeDownloader/yousee-downloader.sh "$CONFIGFILE" "$YOUSEENAME" "$LOCALNAME"
