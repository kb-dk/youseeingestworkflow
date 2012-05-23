#!/bin/bash

pushd . > /dev/null
SCRIPT_PATH="${BASH_SOURCE[0]}";
if ([ -h "${SCRIPT_PATH}" ]) then
  while([ -h "${SCRIPT_PATH}" ]) do cd `dirname "$SCRIPT_PATH"`; SCRIPT_PATH=`readlink "${SCRIPT_PATH}"`; done
fi
cd `dirname ${SCRIPT_PATH}` > /dev/null
SCRIPT_PATH=`pwd`;
popd  > /dev/null

source $SCRIPT_PATH/../config/combinedProperties.sh
source $SCRIPT_PATH/../config/statemonitorClientConfig.sh

NAME="`basename $0 .sh`Config"
CONFIGFILE=`echo ${!NAME}`


function report(){
    COMPONENT=$1
    STATE=$2
    ENTITY=$3
    MESSAGE="${*:4}"
    if [ -n "$MESSAGE" ]; then
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
