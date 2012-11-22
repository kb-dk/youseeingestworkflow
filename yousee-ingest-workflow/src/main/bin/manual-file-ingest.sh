#!/bin/bash

SCRIPT_PATH=$(dirname $(readlink -f $0))
WORKFLOW_SCRIPTS="${SCRIPT_PATH}/../scripts"

FILENAME="$1"

if [ -z $YOUSEE_CONFIG ]; then
	echo "YOUSEE_CONFIG has not been set!"
	exit 1
fi

source "${YOUSEE_CONFIG}/youseedownloader/youseeDownloaderConfig.sh"

FILEPATH="${LOCALPATH}${FILENAME}"
FILEURL="file://${FILEPATH}"

echo "Verify file"
if [ ! -r $FILEPATH ]; then
	echo "File $FILEPATH does not exist or cannot be read."
	exit 2
fi

FILESIZE=$(stat -c%s "$FILEPATH")
STREAMCHECKSUM=$(cat $FILEPATH".md5" | cut -d' ' -f1) 2>/dev/null
THEIRCHECKSUM=$(cat $FILEPATH".headers"  | grep -i "content-md5:" | cut -d' ' -f2 |  sed 's/\s*$//g') 2>/dev/null
if [ -n "$STREAMCHECKSUM" -a "$STREAMCHECKSUM" == "$THEIRCHECKSUM" ]; then
	# NO OP
else
	echo "The checksum from stream and the reported checksum does not match"
	exit 3
fi

echo "Run crosscheck characterisation"
CROSSCHECKOUT="${FILEPATH}.crosscheck"
"${WORKFLOW_SCRIPTS}/crosscheck-characteriser.sh" "$FILENAME" "$FILEURL" > $CROSSCHECKOUT
if [ ! $? -eq 0 ]; then
	echo "Crosscheck failed"
	rm "$CROSSCHECKOUT"
	exit 4
fi

echo "Run ffprobe"
FFPROBEOUT="${FILEPATH}.ffprobe"
FFPROBEERR="${FILEPATH}.ffprobe.err"
"${WORKFLOW_SCRIPTS}/ffprobe-characteriser.sh" "$FILENAME" "$FILEURL" > "$FFPROBEOUT" 2>"$FFPROBEERR"
if [ ! $? -eq 0 ]; then
	echo "FFprobe failed"
	rm "$FFPROBEOUT"
	rm "$FFPROBEERR"
	exit 5
fi
FFPROBEERRXML="${FFPROBEERR}.xml"
echo "<ffprobe:ffprobeStdErrorOutput xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:ffprobe='http://www.ffmpeg.org/schema/ffprobe/stderr'>" > "$FFPROBEERRXML"
cat "$FFPROBEERR" >> "$FFPROBEERRXML"
echo "</ffprobe:ffprobeStdErrorOutput>" >> "$FFPROBEERRXML"

echo "Check Crosscheck output validity"
xmllint --noout --schema "${YOUSEE_CONFIG}/crosscheckprofilevalidator/crosscheck.xsd" "$CROSSCHECKOUT"
if [ ! $? -eq 0 ]; then 
	echo "Crosscheck schema validation failed."
	exit 6
fi

echo "Check FFprobe output validity"
xmllint --noout --schema "${YOUSEE_CONFIG}/ffprobeprofilevalidator/ffprobe.xsd" "$FFPROBEOUT"
if [ ! $? -eq 0 ]; then
        echo "FFprobe schema validation failed."
        exit 7
fi

echo "Ingest file in bitrepository"
BITREPOURL=$("${WORKFLOW_SCRIPTS}/yousee-bitrepository-ingester.sh" "$FILENAME" "$FILEURL" "$FILENAME" "$STREAMCHECKSUM" "$FILESIZE")
if [ ! $? -eq 0 ]; then
	echo "Bitrepository ingest failed"
	exit 8
fi
URL=$(echo "$BITREPOURL" | cut -d":" -f2,3 | sed s/\"//g | sed s/\}//g)

echo "Package metadata"
CHANNELID=$(echo $FILENAME | cut -d'_' -f1)
UNIXSTARTTIME=$(echo $FILE | cut -d'.' -f2 | cut -d'-' -f1)
STARTTIME=$(date -d @$UNIXSTARTTIME +%Y%m%d'T'%H%M%S%z)
UNIXSTOPTIME=$(echo $FILE | cut -d'_' -f3 | cut -d'-' -f1)
STOPTIME=$(date -d @$UNIXSTOPTIME +%Y%m%d'T'%H%M%S%z)
FORMAT=$(grep "$CHANNELID" format-mapping | cut -d' ' -f2)
METADATA="${FILEPATH}.metadata"
"${WORKFLOW_SCRIPTS}/broadcastMetadata-packager.sh" "$FILENAME" "$STREAMCHECKSUM"  "$STOPTIME" "$STARTTIME" "$CHANNELID" "$FORMAT" > "$METADATA"
if [ ! $? -eq 0 ]; then
	echo "Metadata packager failed"
	rm "$METADATA"
	exit 9
fi

echo "Ingest metadata into doms"
DOMSPID=$("${WORKFLOW_SCRIPTS}/yousee-doms-ingester.sh" "$FILENAME" "$URL" "$STREAMCHECKSUM" "$FFPROBEOUT" "$FFPROBEERRXML" "$CROSSCHECKOUT" "$METADATA")
if [ ! $? -eq 0 ]; then
	echo "Doms ingester failed"
	exit 10
fi
PID=$(echo $DOMSPID | cut -d":" -f2,3 | sed s/\"//g | sed s/\}//g)

echo "Ingest metadata into digitv"
DIGITVID=$("${WORKFLOW_SCRIPTS}/yousee-digitv-ingester.sh" "$FILENAME" "$URL" "$CHANNELID" "$STARTTIME" "$STOPTIME")
if [ ! $? -eq 0 ]; then
	echo "Digitv ingester failed"
	exit 11
fi
ID==$(echo $DIGITVID | cut -d":" -f2,3 | sed s/\"//g | sed s/\}//g)

echo "Complete and cleanup" 
"${WORKFLOW_SCRIPTS}/yousee-ingest-workflow-completed.sh" "$FILENAME" "$PID" "$ID" "$URL" "$FILEURL"

rm "$METADATA" "$CROSSCHECKOUT" "$FFPROBEOUT" "$FFPROBEERR" "$FFPROBEERRXML"
exit 0

















