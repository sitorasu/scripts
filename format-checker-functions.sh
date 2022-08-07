#!/bin/bash

# ファイルの終端が改行であるか調べる
check_ends_with_newline() {
  local filename=$1
  # 入力の末尾が改行でないときreadの終了コードは1になる
  tail -n 1 "$filename" | read -r
  if [ $? -eq 1 ]; then
    echo "$filename does not end with newline."
    return 1
  fi
  return 0
}

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
