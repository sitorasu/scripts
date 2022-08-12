#!/bin/bash

# TODO: 終了コードのテストに対応する
assert() {
  local expected=$1
  local actual=$2
  if ! cmp "$expected" "$actual" > /dev/null 2>&1; then
    echo ' ... Failed'
    diff -u "$expected" "$actual"
    exit 1
  fi
  echo ' ... OK'
}
