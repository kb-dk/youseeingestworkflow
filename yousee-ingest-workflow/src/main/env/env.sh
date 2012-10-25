#!/bin/bash

SCRIPT_PATH=$(dirname $(readlink -f $BASH_SOURCE[0]))

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

PERFORMANCELOG=$LOGDIR/performaceLog.tsv


STATE_FAILED="Failed"
STATE_COMPLETED="Completed"
STATE_STARTED="Started"
STATE_DONE="Done"
STATE_STOPPED="Stopped"
STATE_RESTARTED="Restarted"
STATE_QUEUED="Queued"


function logPerformance(){
    local COMPONENT=$1
    local ENTITY=$2
    local TIME=$3
    echo -e "$COMPONENT\t$ENTITY\t$TIME">>$PERFORMANCELOG
}


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

    local PRESERVEDSTATES="preservedStates=$STATE_STOPPED&preservedStates=$STATE_RESTARTED&preservedStates=$STATE_FAILED"

    RESULT=`echo "$STATEBLOB" \
       | curl -s -i -H 'Content-Type: text/xml' -H 'Accept: application/json' -d@- \
          "$STATEMONTITORSERVER/states/$ENTITY?$PRESERVEDSTATES"`
    RETURNCODE="$?"
    if [ "$RETURNCODE" -ne 0 ]; then
        error "$ENTITY" "Failed to communicate with state monitor" "$RESULT"
        exit $RETURNCODE
    fi
    echo "$RESULT" | grep "\"stateName\":\"\($STATE_STOPPED\|$STATE_RESTARTED\)\""
    RETURNCODE="$?"
    if [ "$RETURNCODE" -eq 0 ]; then
        inf "$ENTITY" "Stopped processing due to file having been marked as $STATE_STOPPED, $STATE_RESTARTED or $STATE_FAILED"
        exit 127
    fi

    return 0
}

function reportWorkflowCompleted(){
    report "${yousee.ingest.workflow}" $STATE_DONE $*
}

#Mainly because when we start, we should overwrite restarted states.
function reportWorkflowStarted(){
    local ENTITY=$1

    local STATEBLOB="<state><component>${yousee.ingest.workflow}</component><stateName>$STATE_STARTED</stateName></state>"

    local RESULT
    local RETURNCODE

    local PRESERVEDSTATES="preservedStates=$STATE_STOPPED"

    RESULT=`echo "$STATEBLOB" \
       | curl -s -i -H 'Content-Type: text/xml' -H 'Accept: application/json' -d@- \
          "$STATEMONTITORSERVER/states/$ENTITY?$PRESERVEDSTATES"`
    RETURNCODE="$?"
    if [ "$RETURNCODE" -ne 0 ]; then
        error "$ENTITY" "Failed to communicate with state monitor" "$RESULT"
        exit $RETURNCODE
    fi
    echo "$RESULT" | grep "\"stateName\":\"\($STATE_STOPPED\)\""
    RETURNCODE="$?"
    if [ "$RETURNCODE" -eq 0 ]; then
        inf "$ENTITY" "Stopped processing due to file having been marked as $STATE_STOPPED"
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
        report "$NAME" "$STATE_STARTED" "$ENTITY" "$CMD"
        debug "$ENTITY" "$NAME started:  $CMD"
    fi
    pushd "$WORKINGDIR" > /dev/null

    local tempfile="`mktemp`"
    local OUTPUT
    local RETURNCODE
    local TIMEBEFORE=$(date +%s)
    OUTPUT="`$CMD 2> $tempfile`"
    RETURNCODE="$?"
    local TIMEAFTER=$(date +%s)

    popd > /dev/null

    local MESSAGE=""
    MESSAGE="std out: \n '$OUTPUT' \n std err: \n '"`cat "$tempfile"`"'"
    cat "$tempfile" >2&
    rm "$tempfile"
    echo "$OUTPUT"


    if [ -n "$ENTITY" ]; then
        if [ "$RETURNCODE" -eq "0" ]; then
            debug "$ENTITY" "$NAME $STATE_COMPLETED for $ENTITY: \n $MESSAGE"
            report "$NAME" $STATE_COMPLETED "$ENTITY" "`echo "$OUTPUT"| head -q -n10`"
            logPerformance "$NAME" "$ENTITY" $(echo "$TIMEAFTER - $TIMEBEFORE" | bc)
        else
            error "$ENTITY" "$NAME $STATE_FAILED for $ENTITY: \n $MESSAGE"
            report "$NAME" $STATE_FAILED "$ENTITY" "$OUTPUT" "$MESSAGE"
        fi
    fi
    return "$RETURNCODE"
}
