#!/bin/bash

pushd . > /dev/null
SCRIPT_PATH="${BASH_SOURCE[0]}";
if ([ -h "${SCRIPT_PATH}" ]) then
  while([ -h "${SCRIPT_PATH}" ]) do cd `dirname "$SCRIPT_PATH"`; SCRIPT_PATH=`readlink "${SCRIPT_PATH}"`; done
fi
cd `dirname ${SCRIPT_PATH}` > /dev/null
SCRIPT_PATH=`pwd`;
popd  > /dev/null


if [ -r $SCRIPT_PATH/setenv.sh ]; then
    source $SCRIPT_PATH/setenv.sh
fi


if [ -z "$YOUSEE_HOME" ]; then
   echo "YOUSEE_HOME is not set. Must be set before execution. Exiting"
   exit 1
fi


if [ -z "$TAVERNA_HOME" ]; then
   echo "TAVERNA_HOME is not set. Must be set before execution. Exiting"
   exit 1
fi

if [ -z "$JAVA_HOME" ]; then
   echo "JAVA_HOME is not set. Must be set before execution. Exiting"
   exit 1
fi

if [ -z "$YOUSEE_CONFIG" ]; then
   echo "YOUSEE_CONFIG is not set. Must be set before execution. Exiting"
   exit 1
fi



mkdir -p $YOUSEE_LOGS
mkdir -p $YOUSEE_LOCKS

$TAVERNA_HOME/executeworkflow.sh \
-inmemory \
-inputvalue Ingest_workflow_startDate "$1"  \
"$YOUSEE_WORKFLOWS/Yousee_ingest_workflow.t2flow" \
-outputdir "$YOUSEE_LOGS/$1"

exit 0



