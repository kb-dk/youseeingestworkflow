#!/bin/bash



pushd . > /dev/null
SCRIPT_PATH="${BASH_SOURCE[0]}";
if ([ -h "${SCRIPT_PATH}" ]) then
  while([ -h "${SCRIPT_PATH}" ]) do cd `dirname "$SCRIPT_PATH"`; SCRIPT_PATH=`readlink "${SCRIPT_PATH}"`; done
fi
cd `dirname ${SCRIPT_PATH}` > /dev/null
SCRIPT_PATH=`pwd`;
popd  > /dev/null


export TAVERNA_HOME="/home/yousee/taverna/taverna-workbench-2.4.0/"
export YOUSEE_CONFIG="/home/yousee/Medieplatform-config/"
export JAVA_HOME="/usr/java/jdk1.6.0_32/"

cd $SCRIPT_PATH/..

bin/runWorkflow.sh 2007-05-05
RETURNCODE=$?
#if [ -n "$RETURNCODE" ]; then
#    exit $RETURNCODE
#fi

COUNT=`ls -1 Yousee_Ingest_Workfl_output/Ingest_Workflow_Result/ | grep -v \.error | wc -l`
#echo $COUNT;
if [ "$COUNT" -gt "0" ]; then
    exit 0
else
    exit 1;
fi