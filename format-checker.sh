#!/bin/bash

# - 与えられたソースファイルのフォーマットをチェックする
# - 終了コードは
#   - チェックが正常に完了し、フォーマットの違反がなければ0
#   - チェックが正常に完了し、フォーマットの違反があれば1
#   - チェックが正常に完了しなければ2

filename=$1

# ファイルの終端が改行でなければエラーとする
check_ends_with_newline() {
  local filename=$1
  # 入力の末尾が改行でないときreadの終了コードが1になることを利用する
  tail -n 1 "$filename" | read -r
  if [ $? -eq 1 ]; then
    echo "$filename does not end with newline."
    exit 1
  fi
}

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

check_if_ends_with_newline "$filename"

check_within_80_chars_per_line() {
  local filename=$1
  local ret=0
  # 標準入力から1行ずつ読み出す
  while IFS='' read -r line
  do
    echo "$line"
    # 読み出した行が80桁以内かチェックする
    num_chars=0
    while IFS='' read -r char
    do
      # ASCII文字なら1桁、それ以外なら2桁でカウントする
      echo "$char" | LANG=C grep -q '[[:cntrl:][:print:]]'
      is_ascii=$?
      if [ $is_ascii -eq 0 ]; then
        num_chars=$((num_chars + 1))
      elif [ $is_ascii -eq 1 ]; then
        num_chars=$((num_chars + 2))
      else
        echo 'Unexpected error happened while processing lines.'
        exit 2
      fi
    done < <(echo "$line" | grep -o .)

    echo $num_chars # デバッグ用

    # 80桁を超える行が見つかったら報告
    #   TODO: 行番号が知りたい
    if [ $num_chars -gt 80 ]; then
      ret=1
      echo "${line}: $num_chars"
    fi
  done < "$filename"
  # 80桁を超える行が見つかることなく最後に到達したなら問題なし
  return $ret
}

check_within_80_chars_per_line "$filename"
