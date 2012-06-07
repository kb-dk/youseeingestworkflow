#!/bin/bash

pushd . > /dev/null
SCRIPT_PATH="${BASH_SOURCE[0]}";
if ([ -h "${SCRIPT_PATH}" ]) then
  while([ -h "${SCRIPT_PATH}" ]) do cd `dirname "$SCRIPT_PATH"`; SCRIPT_PATH=`readlink "${SCRIPT_PATH}"`; done
fi
cd `dirname ${SCRIPT_PATH}` > /dev/null
SCRIPT_PATH=`pwd`;
popd  > /dev/null

source $YOUSEE_CONFIG/ingestworkflow/combinedProperties.sh
source $YOUSEE_CONFIG/ingestworkflow/statemonitorClientConfig.sh
source $YOUSEE_CONFIG/ingestworkflow/componentLoggingConfig.sh

source $SCRIPT_PATH/loggingEntity.sh
mkdir -p $LOGDIR

NAME="`basename $0 .sh`Config"
CONFIGFILE=`echo ${!NAME}`


function report(){
    local COMPONENT=$1
    local STATE=$2
    local ENTITY=$3
    local MESSAGE="${*:4}"
    if [ -n "$MESSAGE" ]; then
        MESSAGE="<message><![CDATA[""$MESSAGE""]]></message>"
    else
        MESSAGE=""
    fi
    local STATE="<stateName>$STATE</stateName>"
    local COMPONENT="<component>$COMPONENT</component>"
    local STATEBLOB="<state>$COMPONENT$STATE$MESSAGE</state>"
    if [ -n $STATEMONTITORSERVER ]; then
        echo "$STATEBLOB" \
        | curl -s -i -H 'Content-Type: text/xml' -d@- $STATEMONTITORSERVER/states/$ENTITY > /dev/null
    fi
    return 0
}



function execute() {
    local WORKINGDIR="$1"
    local CMD="$2"
    local NAME="$3"
    local ENTITY="$4"

    if [ -n "$ENTITY" ]; then
        report "$NAME" "Started" "$ENTITY"
    fi
    pushd "$WORKINGDIR" > /dev/null

    local tempfile="`mktemp`"
    local OUTPUT
    OUTPUT="`$CMD 2> $tempfile`"
    RETURNCODE="$?"

    popd > /dev/null

    local MESSAGE=""
    if [ "$RETURNCODE" -eq "0" ]; then
        if [ -n "$ENTITY" ]; then
            MESSAGE= "std out: $OUTPUT \n std err: "`cat "$tempfile"`
            debug "$ENTITY" "$NAME succeeded for $ENTITY: \n $MESSAGE"
            report "$NAME" "Completed" "$ENTITY" "`echo "$OUTPUT"| head -q -n10`"
        fi
        rm "$tempfile"
        echo "$OUTPUT"
        return "0"
    else
        if [ -n "$ENTITY" ]; then
            MESSAGE= "std out: $OUTPUT \n std err: "`cat "$tempfile"`
            error "$ENTITY" "$NAME failed for $ENTITY: \n $MESSAGE"
            report "$NAME" "Failed" "$ENTITY" "$OUTPUT" "$MESSAGE"
        fi
        rm "$tempfile"
        echo "$OUTPUT"
        return "$RETURNCODE"
    fi
}
