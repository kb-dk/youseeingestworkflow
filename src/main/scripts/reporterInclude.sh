#!/bin/bash

source $YOUSEE_HOME/config/statemonitorClientConfig.sh

function report(){
    COMPONENT=$1
    STATE=$2
    MESSAGE=$3
    ENTITY=$4
    if [ -n $MESSAGE ]; then
        MESSAGE="<message>$MESSAGE</message>"
    else
        MESSAGE=""
    fi
    STATE="<stateName>$STATE</stateName>"
    COMPONENT="<component>$COMPONENT</component>"
    STATEBLOB="<state>$COMPONENT$STATE$MESSAGE</state>"
    if [ -n $STATEMONTITORSERVER ]; then
        echo "$STATEBLOB" \
        | curl -s -i -H 'Content-Type: text/xml' -d@- $STATEMONTITORSERVER/states/$ENTITY > /dev/null
    fi
    return 0
}



