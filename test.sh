#!/bin/bash

check_stdout() {
  local expected=$1
  local test_case=$2
  echo -n "$test_case..."
  actual="$(eval "$test_case")"
  if [ "$expected" != "$actual" ]; then
    echo
    echo "  '$expected' expected, but got '$actual'."
    exit 1
  else
    echo OK
  fi
}
