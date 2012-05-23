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
DOMSPID=$2
DIGITVPID=$3
REMOTEURL=$4
LOCALURL=$5


NAME=`basename $0 .sh`
report "$NAME" "Started" "$ENTITY"


echo $DOMSPID
echo $DIGITVPID
echo $REMOTEURL
echo $LOCALURL
RETURNCODE=$?
if [ $RETURNCODE == 0 ];then
    report "$NAME" "Done" "$ENTITY"
else
    report "$NAME" "Failed" "$ENTITY"
fi
exit $RETURNCODE


#TODO rm the downloaded file