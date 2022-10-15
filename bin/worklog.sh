#!/bin/bash

# worklog - 今日の作業ログ用のテキストファイルを作成しVSCodeで開く
#
# synopsis:
#   worklog
#
# expample:
#   worklog
#
# description:
#   worklogコマンドは
#   - 環境変数WORKLOGPATHで指定されたディレクトリに今日の作業ログ用の
#     テキストファイル（YYYY-MM-DD.txt）を作成し、
#   - その1行目に"YYYY-MM-DD"と書き込み、
#   - そのファイルをVSCodeで開く。
#   ただし、YYYY-MM-DD.txtがすでに存在する場合は単にそのファイルを開く。

today="$(date '+%Y-%m-%d')"
filename="${today}.txt"
filepath="${WORKLOGPATH}/${filename}"

if [ ! -e "$filepath" ]; then
  touch "$filepath"
  echo "$today" > "$filepath"
fi

code "$WORKLOGPATH" "$filepath"
