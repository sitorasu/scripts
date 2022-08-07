#!/bin/bash

# - 与えられたソースファイルのフォーマットをチェックする
# - 終了コードは
#   - チェックが正常に完了し、フォーマットの違反がなければ0
#   - チェックが正常に完了し、フォーマットの違反があれば1
#   - チェックが正常に完了しなければ2

filename=$1

# grep -o . が使えるか確認する
#   必ずしも使えないというのを見た気がするので(要出典)
# grepは正常終了したら0か1を返す
grep -o . /dev/null
if [ $? -gt 1 ]; then
  echo "'grep -o' is not supported." >&2
  exit 2
fi

# localeをja_JP.UTF-8に設定する
#   これは日本語が含まれる文字列を正しく1文字ずつ分割するために必要な設定
#   子プロセス(このスクリプト)の環境変数の変更は親プロセス(このスクリプトの呼び出し元)に影響しない
LANG=ja_JP.UTF-8

source format-checker-functions.sh

check_if_ends_with_newline "$filename"
check_within_80_chars_per_line "$filename"
