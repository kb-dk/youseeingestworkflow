#!/bin/bash

rotate_logs() {
    if [ -z $YOUSEE_LOGS ]; then
        echo "$YOUSEE_LOGS is not set. Must be set before logs can be rotated."
        exit 1
    fi

    mv $YOUSEE_LOGS $YOUSEE_LOGS-$(date +%Y%m%d%H%M%S)
    mkdir -p $YOUSEE_LOGS
}
