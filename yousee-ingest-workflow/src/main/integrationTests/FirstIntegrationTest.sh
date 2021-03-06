#!/bin/bash

SCRIPT_PATH=$(dirname $(readlink -f $0))


echo "Running the first integration test."
echo "This tests just ensures that at least one file makes it through the workflow"


cd $SCRIPT_PATH/..

INPUT_DATE=$(date --date="today" --rfc-3339=date)

if [ -d "$YOUSEE_LOGS/$INPUT_DATE" ]; then
  rm -r "$YOUSEE_LOGS/$INPUT_DATE"
fi

$YOUSEE_BIN/runWorkflow.sh "$INPUT_DATE"
RETURNCODE=$?
if [ "$RETURNCODE" -ne "0" ]; then
    exit $RETURNCODE
fi

RESULTDIR=$(cd $YOUSEE_LOGS && ls -1rtd $INPUT_DATE* | tail -1)

COUNT_ALL=$(ls -1 "$YOUSEE_LOGS/$RESULTDIR/Ingest_Workflow_Result/"  | wc -l)
COUNT_NOT_ERRORS=$(ls -1 "$YOUSEE_LOGS/$RESULTDIR/Ingest_Workflow_Result/" | grep -v \.error | wc -l)
#echo $COUNT;
if [ $COUNT_ALL -gt 0 ]; then
    if [ $COUNT_NOT_ERRORS -gt 0 ]; then
        exit 0
    else
        exit 1;
    fi
fi
exit 0