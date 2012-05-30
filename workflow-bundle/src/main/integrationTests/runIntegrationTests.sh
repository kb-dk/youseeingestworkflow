#!/bin/bash

pushd . > /dev/null
SCRIPT_PATH="${BASH_SOURCE[0]}";
if ([ -h "${SCRIPT_PATH}" ]) then
  while([ -h "${SCRIPT_PATH}" ]) do cd `dirname "$SCRIPT_PATH"`; SCRIPT_PATH=`readlink "${SCRIPT_PATH}"`; done
fi
cd `dirname ${SCRIPT_PATH}` > /dev/null
SCRIPT_PATH=`pwd`;
popd  > /dev/null

echo "Running the suite of integration tests"


source $SCRIPT_PATH/setenv.sh

pushd $SCRIPT_PATH > /dev/null

for test in *Test.sh; do
    echo ""
   $SCRIPT_PATH/setup.sh
   $SCRIPT_PATH/$test
   RETURNCODE="$?"
   $SCRIPT_PATH/teardown.sh
   if [ "$RETURNCODE" -ne "0" ]; then
       popd > /dev/null
       exit "$RETURNCODE"
   fi
   echo ""
done

echo "Tests complete, none failed"

popd > /dev/null
