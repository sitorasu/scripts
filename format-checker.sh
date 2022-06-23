#!/bin/bash

# 終了コードは
#   チェックが正常に完了し、問題がなければ0
#   チェックが正常に完了し、問題があれば1
#   チェックが正常に完了しなければ2

# チェック対象のファイル
filename="$1"

# grep -o . が使えるか確認する
#   必ずしも使えないというのを見た気がするので(要出典)
# grepは正常終了したら0か1を返す
grep -o . < /dev/null
if [ $? -gt 1 ]; then
  echo "'grep -o' is not supported." >&2
  exit 2
fi

# localeをja_JP.UTF-8に設定する
# スクリプトの呼び出し元には影響しないはず
# これは日本語が含まれる文字列を正しく1文字ずつ分割するために必要な設定
LANG=ja_JP.UTF-8

# 終了コード
ret=0

# 引数に指定されたファイルを1行ずつ読み出す
while read -r line
do
  # 読み出した行を1文字ずつ分割して配列に入れる　
  chars=()
  while IFS='' read -r char
  do
   chars+=("$char")
  done < <(echo "$line" | grep -o .)

  # 読み出した行が80桁以内かチェックする
  num_chars=0
  for char in "${chars[@]}"
  do
    # ASCII文字なら1桁、それ以外なら2桁でカウントする
    echo "$char" | LANG=C grep '[[:cntrl:][:print:]]' > /dev/null
    is_ascii=$?
    if [ $is_ascii -eq 0 ]; then
      num_chars=$((num_chars + 1))
    elif [ $is_ascii -eq 1 ]; then
      num_chars=$((num_chars + 2))
    else
      echo 'Unexpected error happened while processing the file.'
      exit 2
    fi
  done

  # 80桁を超える行が見つかったら報告
  if [ $num_chars -gt 80 ]; then
    ret=1
    echo "${line}: $num_chars"
  fi
done < "$filename"

# 80桁を超える行が見つかることなく最後に到達したなら問題なし
exit $ret