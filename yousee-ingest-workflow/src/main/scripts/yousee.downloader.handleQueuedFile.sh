#!/bin/bash

SCRIPT_PATH=$(dirname $(readlink -f $0))




ENTITY="$1"
DOWNLOADER_JSON_OUTPUT="$PWD/$2"

NAME=`basename "$0" ".sh" | cut -d'_' -f-2`

source $SCRIPT_PATH/env.sh

CMD="grep \"queued\": $DOWNLOADER_JSON_OUTPUT "
FOUND=`$CMD | wc -l`

if [ "$FOUND" -eq 0 ]; then 
    report "$NAME" $STATE_COMPLETED "$ENTITY"
    cat $DOWNLOADER_JSON_OUTPUT
    debug "$ENTITY" "Component $NAME marked $ENTITY as ok. FOUND was $FOUND, DOWNLOADER was $DOWNLOADER_JSON_OUTPUT. Contents was  `cat $DOWNLOADER_JSON_OUTPUT`"
    exit 0
else
    report "$NAME" $STATE_QUEUED "$ENTITY"
    debug "$ENTITY" "Component $NAME marked $ENTITY as queued"
    exit 1
fi


