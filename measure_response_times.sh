#!/bin/bash

if [[ -n "$DEBUG" ]]; then
  set -x
fi

APP_NAME=instr-response-time

cf target api.$CF_INSTR_TARGET
cf login $CF_INSTR_USER --password $CF_INSTR_PASSWORD --org $CF_INSTR_ORG --space $CF_INSTR_SPACE

INSTR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cf push --memory 1G --path $INSTR_DIR/apps/sinatra-instrumentation --name $APP_NAME -f

RESPONSE_SIZE=${CF_INSTR_RESPONSE_SIZE:-1048576}
APP_URL="http://${APP_NAME}.${CF_INSTR_TARGET}/?response_size=${RESPONSE_SIZE}"

NUM_REQUESTS=${CF_INSTR_NUM_REQUESTS:-3000}
CONCURRENCY=${CF_INSTR_CONCURRENCY:-100}
INSTANCES=${CF_INSTR_INSTANCES:-"1 2 4 8"}

cat > response_time.gnuplot <<EOF
set terminal png size 1024,768
set output 'response_time.png'
set datafile separator ','

set title "Response Time Distribution on ${CF_INSTR_TARGET}\\n($NUM_REQUESTS total requests, $CONCURRENCY concurrent connections, $RESPONSE_SIZE byte response)"
set xlabel "Percentile"
set ylabel "Response Time (ms)"
set key left top
set logscale y

plot \\
EOF

for instances in $INSTANCES; do
  cf scale --instances $instances $APP_NAME
  cf restart $APP_NAME # so that we know all the instances are ready
  ab -v 1 -n $NUM_REQUESTS -c $CONCURRENCY -e response_time_with_headers_${instances}.csv $APP_URL

  # gnuplot will barf if there's a header
  tail -n +2 response_time_with_headers_${instances}.csv > response_time_${instances}.csv

  echo "'response_time_${instances}.csv' title '${instances} instances' with lines, \\" >> response_time.gnuplot
done

# remove that trailing comma from the end of the plot commands
sed -i -e '$ s/,.*$//g' response_time.gnuplot

gnuplot response_time.gnuplot

cf delete $APP_NAME -f
