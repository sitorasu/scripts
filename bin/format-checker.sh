#!/bin/bash

# format-checker - 与えられたソースファイルのフォーマットをチェックする
#
# synopsis:
#   format-checker <filename>
#
# example:
#   format-checker sample.cpp
#
# description:
#   与えられたソースファイルが以下を満たすかチェックする。
#   - 改行で終わっている
#   - 行末に空白がない
#   - 1行が80桁以内である
#
#   終了コードは0, 1, 2のいずれかであり、それぞれ以下を意味する。
#   - 0: チェックが正常に完了し、フォーマットの違反がなかった
#   - 1: チェックが正常に完了し、フォーマットの違反があった
#   - 2: チェックが正常に完了しなかった

filename=$1

# grep -o . が使えるか確認する
#   必ずしも使えないというのを見た気がするので(要出典)
# grepは正常終了したら0か1を返す
grep -o . /dev/null
if [ $? -gt 1 ]; then
  echo "'grep -o' might not be supported." >&2
  exit 2
fi

# localeをja_JP.UTF-8に設定する
#   これは日本語が含まれる文字列を正しく1文字ずつ分割するために必要な設定
#   子プロセス(このスクリプト)の環境変数の変更は親プロセス(このスクリプトの呼び出し元)に影響しない
LANG=ja_JP.UTF-8

# エラーが起きたら即時終了
set -e -o pipefail

script_dir="$(dirname "$0")"
source "$script_dir"/funcs/format-checker-functions.sh

ret=0

for filename in "$@";
do
  # ファイルの存在チェック
  if [ ! -f "$filename" ]; then
    echo "$filename: No such file." >&2
    ret=2
    continue 1
  fi

  # 改行で終わっているか？
  if ! check_ends_with_newline "$filename" && [ $ret -eq 0 ]; then
    ret=1
  fi

  # 行末に空白がないか？
  if ! check_trailing_space "$filename" && [ $ret -eq 0 ]; then
    ret=1
  fi

  # 1行は80桁に収まっているか？
  if ! check_within_80_chars_per_line "$filename" && [ $ret -eq 0 ]; then
    ret=1
  fi
done

exit $ret
