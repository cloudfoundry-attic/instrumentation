#!/bin/bash

APP_NAME=instr-response-time

cf target api.$CF_INSTR_TARGET
cf login $CF_INSTR_USER --password $CF_INSTR_PASSWORD --org $CF_INSTR_ORG --space $CF_INSTR_SPACE

INSTR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cf push --path $INSTR_DIR/apps/sinatra-instrumentation --name $APP_NAME -f

APP_URL="http://${APP_NAME}.${CF_INSTR_TARGET}/?response_size=1048576"

NUM_REQUESTS=3000
CONCURRENCY=100

READY_WAIT=${CF_INSTR_READY_WAIT:-10}
sleep $READY_WAIT

ab -n $NUM_REQUESTS -c $CONCURRENCY -e response_time_with_headers.csv $APP_URL

# gnuplot will barf if there's a header
tail -n +2 response_time_with_headers.csv > response_time.csv

gnuplot -e "set terminal png; set output 'response_time.png'; set datafile separator ','; plot 'response_time.csv' with lines"

cf delete $APP_NAME -f
