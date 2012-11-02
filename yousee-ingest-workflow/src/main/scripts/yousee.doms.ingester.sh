#!/bin/bash

SCRIPT_PATH=$(dirname $(readlink -f $0))




ENTITY=$1
REMOTEURL=$2
CHECKSUM=$3
FFPROBEPROFILE_LOCATION=$4
FFPROBEERROR_LOCATION=$5
CROSSCHECKPROFILE_LOCATION=$6
YOUSEEMETADATA_LOCATION=$7




NAME=`basename $0 .sh`

source $SCRIPT_PATH/common.sh

APPDIR="$YOUSEE_COMPONENTS/${yousee.doms.ingester}"

CMD="$JAVA_HOME/bin/java -cp $APPDIR/bin/*:$APPDIR/external-products/*:`dirname $CONFIGFILE` \
  dk.statsbiblioteket.doms.radiotv.RadioTVIngesterCLI \
 --filename=$ENTITY \
 --url=$REMOTEURL \
 --ffprobe=$FFPROBEPROFILE_LOCATION \
 --ffprobeErrorLog=$FFPROBEERROR_LOCATION \
 --crosscheck=$CROSSCHECKPROFILE_LOCATION \
 --metadata=$YOUSEEMETADATA_LOCATION \
 --config=$CONFIGFILE "

OUTPUT="`execute "$PWD" "$CMD" "$NAME" "$ENTITY"`"
RETURNCODE=$?
echo "$OUTPUT"
exit "$RETURNCODE"

