#!/bin/bash

SCRIPT_PATH=$(dirname $(readlink -f $0))

if [ -r $SCRIPT_PATH/setenv.sh ]; then
    source $SCRIPT_PATH/setenv.sh
fi

if [ -r $SCRIPT_PATH/logRotater.sh ]; then
    source $SCRIPT_PATH/logRotater.sh
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
rotate_logs

TAVERNA_OUT_DIR=`mktemp -d -u --tmpdir=$YOUSEE_LOGS $1-runNr-XXX`

TAVERNA_TEMP_DIR=`mktemp -d --tmpdir=$YOUSEE_LOGS`

export _JAVA_OPTIONS=-Djava.io.tmpdir=$TAVERNA_TEMP_DIR

$TAVERNA_HOME/executeworkflow.sh \
-inmemory \
-inputvalue Ingest_workflow_startDate "$1"  \
"$YOUSEE_WORKFLOWS/Yousee_ingest_workflow.t2flow" \
-outputdir $TAVERNA_OUT_DIR

rm -rf $TAVERNA_TEMP_DIR

exit 0



