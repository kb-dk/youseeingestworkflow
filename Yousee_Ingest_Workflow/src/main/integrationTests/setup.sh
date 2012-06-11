#!/bin/bash

echo "Running setup"
$YOUSEE_CONFIG/test-data-canopus/cleanAll.sh

$YOUSEE_BIN/setupTaverna.sh
echo "Setup done"