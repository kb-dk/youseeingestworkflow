#!/bin/bash

SCRIPT_PATH=$(dirname $(readlink -f $0))



ENTITY=$1
LOCALFILE=$2

NAME=`basename $0 .sh`

source $SCRIPT_PATH/common.sh

APPDIR="$YOUSEE_COMPONENTS/${crosscheck.characteriser}"

CMD="$APPDIR/bin/crosscheckCharacterise.sh $LOCALFILE $CONFIGFILE"

OUTPUT="`execute "$PWD" "$CMD" "$NAME" "$ENTITY"`"
RETURNCODE=$?
echo "$OUTPUT"
exit "$RETURNCODE"

