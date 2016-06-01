#!/bin/bash

set -ueo pipefail

_trap_error() {
  _name="$0"                # name of the script
  _lastline="$1"            # argument 1: last line of error occurence
  _lasterr="$2"             # argument 2: error code of last command
  echo "exit ${_lasterr} (${_name}: line ${_lastline}) "
  exit ${_lasterr}
}
trap '_trap_error ${LINENO} $?' ERR


echo "Start Telegraf tests"

k=0
isOk=false
for k in $(seq 0 15); do
    echo -e "-- Check database #$k ---------------------------"
    output=$(curl "http://192.168.100.10:8086/query?q=SHOW+MEASUREMENTS&db=telegraf" 2>/dev/null || true)
    echo "Output: $output"

    if [[ $(echo "$output" | jq '.results[].error' 2>/dev/null| grep 'database not found: telegraf' | wc -l) -eq 1 ]]; then
        echo "Waiting database creation..."
    else
        if [[ $(echo "$output" | jq '.results[].series[].values[][0]' 2>/dev/null | grep 'cpu' | wc -l) -gt 0 ]]; then
            echo "Success. Table CPU found."
            isOk=true
            break
        fi
    fi

    sleep 10
done

if [[ $isOk != true ]]; then
    echo "FAILED! Database not created after multiple attempts."
    exit 1
else
    isOk=false
    for k in $(seq 0 10); do
        echo -e "-- Check metrics #$k ---------------------------"
        output=$(curl "http://192.168.100.10:8086/query?q=select+*+from+cpu+limit+1&db=telegraf" 2>/dev/null || true)
        echo "Output: $output"

        if [[ $(echo "$output" | jq '.results[].series[].columns[]' 2>/dev/null | grep 'time' | wc -l) -eq 1 ]]; then
            echo "Success. Metric CPU found."
            isOk=true
            break
        fi
        sleep 10
    done
fi

if [[ $isOk != true ]]; then
    echo "FAILED! Database created, but not metrics inside after multiple attempts."
    exit 1
else
    echo "** TEST IS SUCCESSFUL **"
fi

echo "End of tests"
