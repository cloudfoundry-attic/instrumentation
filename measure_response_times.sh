#!/bin/bash

if [[ -n "$DEBUG" ]]; then
  set -x
fi

APP_NAME=instr-response-time

cf target api.$CF_INSTR_TARGET
cf login $CF_INSTR_USER --password $CF_INSTR_PASSWORD --org $CF_INSTR_ORG --space $CF_INSTR_SPACE

INSTR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cf push --path $INSTR_DIR/apps/sinatra-instrumentation --name $APP_NAME -f

APP_URL="http://${APP_NAME}.${CF_INSTR_TARGET}/?response_size=1048576"

NUM_REQUESTS=${CF_INSTR_NUM_REQUESTS:-3000}
CONCURRENCY=${CF_INSTR_CONCURRENCY:-100}

READY_WAIT=${CF_INSTR_READY_WAIT:-10}
sleep $READY_WAIT

ab -n $NUM_REQUESTS -c $CONCURRENCY -e response_time_with_headers.csv $APP_URL

# gnuplot will barf if there's a header
tail -n +2 response_time_with_headers.csv > response_time.csv

gnuplot <<EOF
set terminal png
set output 'response_time.png'
set datafile separator ','

set title "Response Time Distribution ($NUM_REQUESTS total requests, $CONCURRENCY concurrent connections)"
set xlabel "Percentile"
set ylabel "Response Time (ms)"

plot 'response_time.csv' title '1 instance' with lines
EOF

cf delete $APP_NAME -f
