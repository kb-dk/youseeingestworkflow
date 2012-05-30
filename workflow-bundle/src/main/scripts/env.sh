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
source $SCRIPT_PATH/../config/componentLoggingConfig.sh


source $SCRIPT_PATH/logging.sh

NAME="`basename $0 .sh`Config"
CONFIGFILE=`echo ${!NAME}`


function report(){
    local COMPONENT=$1
    local STATE=$2
    local ENTITY=$3
    local MESSAGE="${*:4}"
    if [ -n "$MESSAGE" ]; then
        MESSAGE="<message>$MESSAGE</message>"
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

    report "$NAME" "Started" "$ENTITY"
    pushd "$WORKINGDIR" > /dev/null

    local tempfile="`mktemp`"
    local OUTPUT
    OUTPUT="`$CMD 2> $tempfile`"
    RETURNCODE="$?"

    popd > /dev/null


    if [ "$RETURNCODE" -eq "0" ]; then
        debug "$NAME succeeded for $ENTITY \n \
        std err was \"`cat $tempfile`\" \n \
        std out was: \"$OUTPUT\""
        rm "$tempfile"
        echo "$OUTPUT"
        report "$NAME" "Completed" "$ENTITY"
        return "0"
    else
        error "$NAME succeeded for $ENTITY \n \
        std err was \"`cat $tempfile`\" \n \
        std out was: \"$OUTPUT\""
        rm "$tempfile"
        report "$NAME" "Failed" "$ENTITY"
        return "$RETURNCODE"
    fi
}