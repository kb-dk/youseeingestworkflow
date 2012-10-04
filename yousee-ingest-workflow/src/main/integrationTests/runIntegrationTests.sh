#!/bin/bash

SCRIPT_PATH=$(dirname $(readlink -f $0))

echo "Running the suite of integration tests"


source $SCRIPT_PATH/../bin/setenv.sh

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
