#!/bin/bash

pushd . > /dev/null
SCRIPT_PATH="${BASH_SOURCE[0]}";
if ([ -h "${SCRIPT_PATH}" ]) then
  while([ -h "${SCRIPT_PATH}" ]) do cd `dirname "$SCRIPT_PATH"`; SCRIPT_PATH=`readlink "${SCRIPT_PATH}"`; done
fi
cd `dirname ${SCRIPT_PATH}` > /dev/null
SCRIPT_PATH=`pwd`;
popd  > /dev/null



ENTITY=$1
YOUSEENAME=$2
LOCALNAME=$3

NAME=`basename $0 .sh`

source $SCRIPT_PATH/env.sh

report "${yousee.ingest.workflow}" "Started" "$ENTITY"

CMD="$YOUSEE_COMPONENTS/${yousee.downloader}/bin/yousee-downloader.sh $CONFIGFILE $YOUSEENAME $LOCALNAME"

OUTPUT="`execute "$PWD" "$CMD" "$NAME" "$ENTITY"`"
RETURNCODE=$?
echo "$OUTPUT"
exit "$RETURNCODE"
