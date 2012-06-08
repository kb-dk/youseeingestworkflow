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
CHECKSUM=$3
FFPROBEPROFILE_LOCATION=$4
CROSSCHECKPROFILE_LOCATION=$5
YOUSEEMETADATA_LOCATION=$6




NAME=`basename $0 .sh`

APPDIR="$YOUSEE_COMPONENTS/$NAME"

CMD="$JAVA_HOME/bin/java -cp $APPDIR/bin/*:$APPDIR/external-products/*:`dirname $CONFIGFILE` \
 dk.statsbiblioteket.doms.yousee.YouseeIngesterCLI \
 -filename $ENTITY \
 -url $REMOTEURL \
 -ffprobe $FFPROBEPROFILE_LOCATION \
 -crosscheck $CROSSCHECKPROFILE_LOCATION \
 -metadata $YOUSEEMETADATA_LOCATION \
 -config $CONFIGFILE "

OUTPUT="`execute "$PWD" "$CMD" "$NAME" "$ENTITY"`"
RETURNCODE=$?
echo "$OUTPUT"
exit "$RETURNCODE"

