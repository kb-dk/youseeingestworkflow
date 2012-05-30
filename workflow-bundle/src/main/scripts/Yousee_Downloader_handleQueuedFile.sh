#!/bin/bash

pushd . > /dev/null
SCRIPT_PATH="${BASH_SOURCE[0]}";
if ([ -h "${SCRIPT_PATH}" ]) then
  while([ -h "${SCRIPT_PATH}" ]) do cd `dirname "$SCRIPT_PATH"`; SCRIPT_PATH=`readlink "${SCRIPT_PATH}"`; done
fi
cd `dirname ${SCRIPT_PATH}` > /dev/null
SCRIPT_PATH=`pwd`;
popd  > /dev/null

echo "CALLED"
echo "CALLED" >@2

source $SCRIPT_PATH/env.sh

ENTITY=$1
DOWNLOADER_JSON_OUTPUT=$2

NAME=`basename $0 .sh | cut -d'_' -f-2`

CMD="grep \"queued\": $DOWNLOADER_JSON_OUTPUT | wc -l"
#echo "$CMD was the command"
FOUND=`$CMD`
#echo "$FOUND was found"

if [ "$FOUND" -eq "0" ]; then \
   cat $DOWNLOADER_JSON_OUTPUT
   exit 0
else
    report "$NAME" "Queued" "$ENTITY"
    cat $DOWNLOADER_JSON_OUTPUT
    exit 1
fi


#LOCALNAME=`cat $DOWNLOADER_JSON_OUTPUT | grep "localName" | cut -d'"' -f4`
#YOUSEENAME=`cat $DOWNLOADER_JSON_OUTPUT | grep "youseeName" | cut -d'"' -f4`

