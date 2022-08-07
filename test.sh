#!/bin/bash

check_stdout() {
  local expected=$1
  local script_name=$2
  local args=( "${@:3}" )
  echo -n "$script_name ${args[*]}..."
  actual="$($script_name "${args[@]}")"
  if [ "$expected" != "$actual" ]; then
    echo
    echo "  '$expected' expected, but got '$actual'."
    exit 1
  else
    echo OK
  fi
}
