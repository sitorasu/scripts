#!/bin/zsh
# shebangはzshでないと通知が文字化けする

# timer - 指定時間後に通知する
#
# synopsis:
#   timer <minutes>
#
# example:
#   timer 5
#
# discription:
#   整数 minutes を指定すると、現在時刻から minutes 分後に通知する。
#   通知のメッセージは「n 分経ちました(hh:mm-hh:mm)」。
#
# note:
#   - 以下のようにバックグラウンドで使うのが良さげ。
#     timer.sh 5 &
#
#   - timer hh:mm で直近の時刻 hh:mm に通知するという機能の追加を検討したが、
#     時刻の計算が面倒で断念。

# 入力値の判定

# 引数の数の確認
if [ $# != 1 ]; then
  echo 'This command requires exactly one argument.'
  return 1
fi
# 整数であることの確認
# exprは計算が成功したとき0または1を返す
# exprの計算が成功するのはオペランドが整数のときのみ
# $(())は整数以外も計算できるためexprの代用にはならない
expr "$1" + 1 > /dev/null 2>&1
if [ $? -gt 1 ]; then
  echo 'invalid argument.'
  return 1
fi

# 時刻を計算してタイマーを開始
minutes=$1
start_time=$(date +%R)
end_time=$(date -v+"${minutes}"M +%R)
sleep $((60 * minutes))
osascript -e "display notification \
  \"$minutes分経ちました($start_time-$end_time)\""
afplay -v 5 /System/Library/Sounds/Blow.aiff
