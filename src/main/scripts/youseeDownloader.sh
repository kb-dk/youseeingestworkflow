#!/bin/bash

CONFIGFILE=$1
YOUSEENAME=$2
LOCALNAME=$3

$YOUSEE_HOME/components/youseeDownloader/yousee-downloader.sh "$CONFIGFILE" "$YOUSEENAME" "$LOCALNAME"
