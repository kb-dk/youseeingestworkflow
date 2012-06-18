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
DOMSPID=$2
DIGITVPID=$3
REMOTEURL=$4
LOCALURL=$5

FILENAME="${LOCALURL#"file://"}"

NAME=`basename $0 .sh`
source $SCRIPT_PATH/env.sh

report "$NAME" "Started" "$ENTITY"


echo $DOMSPID
echo $DIGITVPID
echo $REMOTEURL
echo $LOCALURL
rm $FILENAME
report "$NAME" "Completed" "$ENTITY" "$NAME succeeded for $ENTITY"
reportWorkflowCompleted "$ENTITY" "$WORKFLOW succeeded for $ENTITY"
inf "$ENTITY" "$NAME succeeded for $ENTITY"
exit "0"


