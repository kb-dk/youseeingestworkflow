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


INPUT=$1

NAME=`basename $0 .sh`
report "$NAME" "Started" "$INPUT"


cat $YOUSEE_HOME/examples/download_initiator_output.json


#pushd $YOUSEE_CONFIG > /dev/null
#$JAVA_HOME/bin/java -cp $YOUSEE_HOME/components/downloadInitiatorLibs/ingest_initiator_impl-*.jar:$YOUSEE_HOME/components/downloadInitiatorLibs/* \
#dk.statsbiblioteket.mediaplatform.ingest.mediafilesinitiator.IngestMediaFilesInitiatorCLI "$CONFIGFILE" "$INPUT"
#popd > /dev/null


RETURNCODE=$?
if [ $RETURNCODE == 0 ];then
   report "$NAME" "Completed" "$ENTITY"
else
    report "$NAME" "Failed" "$ENTITY"
fi
exit $RETURNCODE