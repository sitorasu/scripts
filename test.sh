#!/bin/bash

check() {
  expected=$1
  script_name=$2
  args=( "${@:3}" )
  echo -n "$script_name ${args[*]}..."
  actual="$($script_name "${args[@]}")"
  if [ "$expected" != "$actual" ]; then
    echo
    echo "'$expected' expected, but got '$actual.'"
    exit 1
  else
    echo OK
  fi
}

check 'This command requires exactly one argument.' timer
check 'invalid argument.' timer not_a_number
check 'invalid argument.' timer 12ab
check 'invalid argument.' timer ab12
