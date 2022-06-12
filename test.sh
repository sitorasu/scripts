#!/bin/bash

check() {
  expected=$1
  script_name=$2
  args="${@:3}"
  echo -n "$script_name $args..."
  actual="$($script_name $args)"
  if [ "$expected" != "$actual" ]; then
    echo
    echo "'$expected' expected, but got '$actual.'"
    exit 1
  else
    echo OK
  fi
}

check 'number of arguments must be 1.' timer.sh
check 'invalid argument.' timer.sh not_a_number
check 'invalid argument.' timer.sh 12ab
check 'invalid argument.' timer.sh ab12
