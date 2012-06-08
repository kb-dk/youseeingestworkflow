#!/bin/bash

pushd . > /dev/null
SCRIPT_PATH="${BASH_SOURCE[0]}";
if ([ -h "${SCRIPT_PATH}" ]) then
  while([ -h "${SCRIPT_PATH}" ]) do cd `dirname "$SCRIPT_PATH"`; SCRIPT_PATH=`readlink "${SCRIPT_PATH}"`; done
fi
cd `dirname ${SCRIPT_PATH}` > /dev/null
SCRIPT_PATH=`pwd`;
popd  > /dev/null



if [ -r $SCRIPT_PATH/setenv.sh ]; then
    source $SCRIPT_PATH/setenv.sh
fi



if [ -z "$TAVERNA_HOME" ]; then
   echo "TAVERNA_HOME is not set. Must be set before execution. Exiting"
   exit 1
fi


VERSION=`head -1 $TAVERNA_HOME/release-notes.txt | sed 's/.$//' | cut -d' ' -f4`
LIB="$HOME/.taverna-$VERSION/lib/"
mkdir -p $LIB
cp -u $YOUSEE_DEPENDENCIES/*.jar $LIB
