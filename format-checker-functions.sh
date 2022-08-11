#!/bin/bash

# ファイルの終端が改行であるか調べる
check_ends_with_newline() {
  local filename=$1
  # 入力の末尾が改行でないときreadの終了コードは1になる
  tail -n 1 "$filename" | read -r
  if [ $? -eq 1 ]; then
    echo "The file does not end with newline."
    return 1
  fi
  return 0
}

# 空白で終わっている行を報告する
check_trailing_space() {
  local filename=$1
  local line_num=1
  while IFS='' read -r line || [ -n "$line" ]
  do
    if [ "${line: -1}" = ' ' ]; then
      echo "$filename:$line_num: Trailing space."
    fi
    line_num=$((line_num + 1))
  done < "$filename"
}

# 引数の文字列の文字数を、ASCII文字なら1文字、それ以外なら2文字でカウントして表示する
count_chars_in_line() {
  local line=$1
  local num_chars=0
  # 行を1文字ずつ(改行で)分割して読み出す
  #   IFS='' は行の前後の空白が読み飛ばされる問題の対策
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
      echo 'Unexpected error happened while processing lines.' >&2
      exit 2
    fi
  done < <(echo "$line" | grep -o .)
  echo $num_chars
}

# ファイルの各行が80桁以内か調べる
check_within_80_chars_per_line() {
  local filename=$1
  local ret=0
  local line_num=1
  # ファイルから1行ずつ読み出す
  #   IFS='' は行の前後の空白が読み飛ばされる問題の対策
  #   || の右辺は最終行が改行で終わっていない場合に処理されない問題の対策
  while IFS='' read -r line || [ -n "$line" ]
  do
    local num_chars
    num_chars=$(count_chars_in_line "$line")
    # 80桁を超える行が見つかったら報告
    #   TODO: 行番号が知りたい
    if [ "$num_chars" -gt 80 ]; then
      ret=1
      echo "$filename:$line_num: $num_chars chars."
      echo "$line"
    fi
    line_num=$((line_num + 1))
  done < "$filename"
  return $ret
}
