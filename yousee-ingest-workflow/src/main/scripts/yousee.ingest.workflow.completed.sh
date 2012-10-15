#!/bin/bash

SCRIPT_PATH=$(dirname $(readlink -f $BASH_SOURCE[0]))


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
rm $FILENAME.*
report "$NAME" "Completed" "$ENTITY" "$NAME succeeded for $ENTITY"
reportWorkflowCompleted "$ENTITY" "$WORKFLOW succeeded for $ENTITY"
inf "$ENTITY" "$NAME succeeded for $ENTITY"
exit 0


