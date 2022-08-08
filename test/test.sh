#!/bin/bash

# 与えられたコマンドの標準出力が期待するものであるかチェックする
# FIXME: テストケースが書きにくい
# FIXME: テストがtestディレクトリ内でしか実施できない
# TODO: 終了コードをテストできるようにする
# TODO: テストの入出力をファイルで与えられるようにする
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
