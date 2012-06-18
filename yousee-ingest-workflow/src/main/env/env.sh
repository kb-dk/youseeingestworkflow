#!/bin/bash

pushd . > /dev/null
SCRIPT_PATH="${BASH_SOURCE[0]}";
if ([ -h "${SCRIPT_PATH}" ]) then
  while([ -h "${SCRIPT_PATH}" ]) do cd `dirname "$SCRIPT_PATH"`; SCRIPT_PATH=`readlink "${SCRIPT_PATH}"`; done
fi
cd `dirname ${SCRIPT_PATH}` > /dev/null
SCRIPT_PATH=`pwd`;
popd  > /dev/null

source $YOUSEE_WORKFLOW_CONFIG/combinedProperties.sh
source $YOUSEE_WORKFLOW_CONFIG/statemonitorClientConfig.sh
source $YOUSEE_WORKFLOW_CONFIG/componentLoggingConfig.sh

source $SCRIPT_PATH/loggingEntity.sh
mkdir -p $LOGDIR

CONFIGNAME="$NAME"
CONFIGNAME="${CONFIGNAME//[\- _]/}"
CONFIGNAME="${CONFIGNAME,,}"
CONFIGNAME="${CONFIGNAME}Config"
CONFIGFILE="${!CONFIGNAME}"
if [ -z "$CONFIGFILE" ]; then
   CONFIGFILE="NOT_SET"
fi


function report(){
    local COMPONENT=$1
    local STATE=$2
    local ENTITY=$3
    local MESSAGE="${*:4}"

    if [ -n "$MESSAGE" ]; then
        #MESSAGE="${MESSAGE:0:$MESSAGE_LENGTH}"
        MESSAGE=`echo -e "<message><![CDATA[""$MESSAGE""]]></message>"`
    else
        MESSAGE=""
    fi
    local STATE="<stateName>$STATE</stateName>"
    local COMPONENT="<component>$COMPONENT</component>"
    local STATEBLOB="<state>$COMPONENT$STATE$MESSAGE</state>"

    local RESULT
    local RETURNCODE

    RESULT=`echo "$STATEBLOB" \
       | curl -s -i -H 'Content-Type: text/xml' -H 'Accept: application/json' -d@- \
          "$STATEMONTITORSERVER/states/$ENTITY?preservedStates=Stopped&preservedStates=Restarted"`
    RETURNCODE="$?"
    if [ "$RETURNCODE" -ne 0 ]; then
        error "$ENTITY" "Failed to communicate with state monitor" "$RESULT"
        exit $RETURNCODE
    fi
    echo "$RESULT" | grep '"stateName":"\(Stopped\|Restarted\)"'
    RETURNCODE="$?"
    if [ "$RETURNCODE" -eq 0 ]; then
        inf "$ENTITY" "Stopped processing due to file having been marked as stopped or restarted"
        exit 127
    fi

    return 0
}

function reportWorkflowCompleted(){
    report "${yousee.ingest.workflow}" "Done" $*
}

#Mainly because when we start, we should overwrite restarted states.
function reportWorkflowStarted(){
    local ENTITY=$1

    local STATEBLOB="<state><component>${yousee.ingest.workflow}</component><stateName>Started</stateName></state>"

    local RESULT
    local RETURNCODE

    RESULT=`echo "$STATEBLOB" \
       | curl -s -i -H 'Content-Type: text/xml' -H 'Accept: application/json' -d@- \
          "$STATEMONTITORSERVER/states/$ENTITY?preservedStates=Stopped"`
    RETURNCODE="$?"
    if [ "$RETURNCODE" -ne 0 ]; then
        error "$ENTITY" "Failed to communicate with state monitor" "$RESULT"
        exit $RETURNCODE
    fi
    echo "$RESULT" | grep '"stateName":"\(Stopped\)"'
    RETURNCODE="$?"
    if [ "$RETURNCODE" -eq 0 ]; then
        inf "$ENTITY" "Stopped processing due to file having been marked as stopped"
        exit 127
    fi
    return 0
}


function execute() {
    local WORKINGDIR="$1"
    local CMD="$2"
    local NAME="$3"
    local ENTITY="$4"

    if [ -n "$ENTITY" ]; then
        report "$NAME" "Started" "$ENTITY" "$CMD"
        debug "$ENTITY" "$NAME started:  $CMD"
    fi
    pushd "$WORKINGDIR" > /dev/null

    local tempfile="`mktemp`"
    local OUTPUT
    local RETURNCODE
    OUTPUT="`$CMD 2> $tempfile`"
    RETURNCODE="$?"

    popd > /dev/null

    local MESSAGE=""
    MESSAGE="std out: \n '$OUTPUT' \n std err: \n '"`cat "$tempfile"`"'"
    rm "$tempfile"
    echo "$OUTPUT"

    if [ -n "$ENTITY" ]; then
        if [ "$RETURNCODE" -eq "0" ]; then
            debug "$ENTITY" "$NAME succeeded for $ENTITY: \n $MESSAGE"
            report "$NAME" "Completed" "$ENTITY" "`echo "$OUTPUT"| head -q -n10`"
        else
            error "$ENTITY" "$NAME failed for $ENTITY: \n $MESSAGE"
            report "$NAME" "Failed" "$ENTITY" "$OUTPUT" "$MESSAGE"
        fi
    fi
    return "$RETURNCODE"
}
