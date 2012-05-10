#!/bin/bash

CONFIGFILE=$1
YOUSEENAME=$2
LOCALNAME=$3


echo "{"
echo "\"localFileUrl\" : \"file:///tmp/$LOCALNAME\","
echo    "\"checksum\" : \"DEADFEAT\","
echo    "\"fileSize\": 2048"
echo "}"
