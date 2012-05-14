#!/bin/bash

STATEMONTITORSERVER="http://localhost:9998/workflowstatemonitor"

function report(){
    COMPONENT=$1
    STATE=$2
    MESSAGE=$3
    ENTITY=$4
    echo "<state><component>$COMPONENT</component><stateName>$STATE</stateName><message>$MESSAGE</message></state>" \
     | curl -s -i -H 'Content-Type: text/xml' -d@- $STATEMONTITORSERVER/states/$ENTITY > /dev/null
}



