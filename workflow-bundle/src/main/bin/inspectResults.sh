#!/bin/bash

COUNT=`ls -1 Yousee_Ingest_Workfl_output/Ingest_Workflow_Result/ | grep -v \.error | wc -l`
#echo $COUNT;
if [ "$COUNT" -gt "0" ]; then
    exit 0
else
    exit 1;
fi