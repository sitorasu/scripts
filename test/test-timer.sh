#!/bin/bash

source test.sh
alias timer=../timer.sh

expected=$(mktemp -t expected)
actual=$(mktemp -t actual)

trap 'rm $expected $actual' EXIT

cat <<'EOF' > "$expected"
This command requires exactly one argument.
EOF
timer > "$actual"
echo -n "timer ... "
assert "$expected" "$actual"

cat <<'EOF' > "$expected"
invalid argument.
EOF
timer not_a_number > "$actual"
echo -n "timer not_a_number ... "
assert "$expected" "$actual"

cat <<'EOF' > "$expected"
invalid argument.
EOF
timer 12ab > "$actual"
echo -n "timer 12ab ... "
assert "$expected" "$actual"

cat <<'EOF' > "$expected"
invalid argument.
EOF
timer ab12 > "$actual"
echo -n "timer ab12 ... "
assert "$expected" "$actual"
