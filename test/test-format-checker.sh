#!/bin/bash

# このスクリプトが置かれているディレクトリに移動する
# (以下では、パスはすべてこのスクリプトからの相対パスで記述する)
cd "$(dirname "$0")" || exit

source test.sh
source ../bin/funcs/format-checker-functions.sh

expected=$(mktemp -t expected)
actual=$(mktemp -t actual)

trap 'rm $expected $actual' EXIT

# unit tests (tests for functions)

cat <<'EOF' > "$expected"
EOF
check_ends_with_newline test-format-checker-files/trailing-space.txt > "$actual"
echo -n "check_ends_with_newline test-format-checker-files/trailing-space.txt"
assert "$expected" "$actual"

cat <<'EOF' > "$expected"
test-format-checker-files/no-end-newline.txt does not end with newline.
EOF
check_ends_with_newline test-format-checker-files/no-end-newline.txt > "$actual"
echo -n "check_ends_with_newline test-format-checker-files/no-end-newline.txt"
assert "$expected" "$actual"

cat <<'EOF' > "$expected"
test-format-checker-files/trailing-space.txt:2: Trailing space.
test-format-checker-files/trailing-space.txt:5: Trailing space.
EOF
check_trailing_space test-format-checker-files/trailing-space.txt > "$actual"
echo -n "check_trailing_space test-format-checker-files/trailing-space.txt"
assert "$expected" "$actual"

cat <<'EOF' > "$expected"
9
EOF
count_chars_in_line abcdefghi > "$actual"
echo -n "count_chars_in_line abcdefghi"
assert "$expected" "$actual"

cat <<'EOF' > "$expected"
9
EOF
count_chars_in_line '  ab  c  ' > "$actual"
echo -n "count_chars_in_line '  ab  c  '"
assert "$expected" "$actual"

cat <<'EOF' > "$expected"
9
EOF
count_chars_in_line 'あいうabc' > "$actual"
echo -n "count_chars_in_line 'あいうabc'"
assert "$expected" "$actual"

cat <<'EOF' > "$expected"
0
EOF
count_chars_in_line '' > "$actual"
echo -n "count_chars_in_line ''"
assert "$expected" "$actual"

cat <<'EOF' > "$expected"
5
EOF
count_chars_in_line '     ' > "$actual"
echo -n "count_chars_in_line '     '"
assert "$expected" "$actual"

cat <<'EOF' > "$expected"
5
EOF
# shellcheck disable=SC2016
count_chars_in_line '$hoge' > "$actual"
echo -n "count_chars_in_line '\$hoge'"
assert "$expected" "$actual"

cat <<'EOF' > "$expected"
5
EOF
count_chars_in_line '*hoge' > "$actual"
echo -n "count_chars_in_line '*hoge'"
assert "$expected" "$actual"

cat <<'EOF' > "$expected"
8
EOF
count_chars_in_line 'hoge.txt' > "$actual"
echo -n "count_chars_in_line 'hoge.txt'"
assert "$expected" "$actual"

cat <<'EOF' > "$expected"
10
EOF
count_chars_in_line '// /* */ #' > "$actual"
echo -n "count_chars_in_line '// /* */ #'"
assert "$expected" "$actual"

cat <<'EOF' > "$expected"
80
EOF
count_chars_in_line 12345678901234567890123456789012345678901234567890123456789012345678901234567890 > "$actual"
echo -n "count_chars_in_line 12345678901234567890123456789012345678901234567890123456789012345678901234567890"
assert "$expected" "$actual"

cat <<'EOF' > "$expected"
80
EOF
count_chars_in_line ああああああああああああああああああああああああああああああああああああああああ > "$actual"
echo -n "count_chars_in_line ああああああああああああああああああああああああああああああああああああああああ"
assert "$expected" "$actual"

cat <<'EOF' > "$expected"
96
EOF
count_chars_in_line あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをん！？ > "$actual"
echo -n "count_chars_in_line あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをん！？"
assert "$expected" "$actual"

cat <<'EOF' > "$expected"
EOF
check_within_80_chars_per_line test-format-checker-files/trailing-space.txt > "$actual"
echo -n "check_within_80_chars_per_line test-format-checker-files/trailing-space.txt"
assert "$expected" "$actual"

cat <<'EOF' > "$expected"
test-format-checker-files/more-than-80-chars-line.txt:5: 81 chars.
test-format-checker-files/more-than-80-chars-line.txt:8: 81 chars.
EOF
check_within_80_chars_per_line test-format-checker-files/more-than-80-chars-line.txt > "$actual"
echo -n "check_within_80_chars_per_line test-format-checker-files/more-than-80-chars-line.txt"
assert "$expected" "$actual"

# integration test (test for format-checker.sh, the main script)

cat <<'EOF' > "$expected"
non-existent-file.txt: No such file.
EOF
../bin/format-checker.sh non-existent-file.txt 2> "$actual"
echo -n "../bin/format-checker.sh non-existent-file.txt"
assert "$expected" "$actual"

cat <<'EOF' > "$expected"
test-format-checker-files/no-end-newline.txt:1: Year is not updated.
test-format-checker-files/no-end-newline.txt does not end with newline.
EOF
../bin/format-checker.sh test-format-checker-files/no-end-newline.txt > "$actual"
echo -n "../bin/format-checker.sh test-format-checker-files/no-end-newline.txt"
assert "$expected" "$actual"

cat <<'EOF' > "$expected"
test-format-checker-files/trailing-space.txt:1: Year is not updated.
test-format-checker-files/trailing-space.txt:2: Trailing space.
test-format-checker-files/trailing-space.txt:5: Trailing space.
EOF
../bin/format-checker.sh test-format-checker-files/trailing-space.txt > "$actual"
echo -n "../bin/format-checker.sh test-format-checker-files/trailing-space.txt"
assert "$expected" "$actual"

cat <<'EOF' > "$expected"
test-format-checker-files/more-than-80-chars-line.txt:1: Year is not updated.
test-format-checker-files/more-than-80-chars-line.txt:5: 81 chars.
test-format-checker-files/more-than-80-chars-line.txt:8: 81 chars.
EOF
../bin/format-checker.sh test-format-checker-files/more-than-80-chars-line.txt > "$actual"
echo -n "../bin/format-checker.sh test-format-checker-files/more-than-80-chars-line.txt"
assert "$expected" "$actual"

cat <<'EOF' > "$expected"
non-existent-file.txt: No such file.
test-format-checker-files/no-end-newline.txt:1: Year is not updated.
test-format-checker-files/no-end-newline.txt does not end with newline.
test-format-checker-files/trailing-space.txt:1: Year is not updated.
test-format-checker-files/trailing-space.txt:2: Trailing space.
test-format-checker-files/trailing-space.txt:5: Trailing space.
test-format-checker-files/more-than-80-chars-line.txt:1: Year is not updated.
test-format-checker-files/more-than-80-chars-line.txt:5: 81 chars.
test-format-checker-files/more-than-80-chars-line.txt:8: 81 chars.
EOF
../bin/format-checker.sh non-existent-file.txt test-format-checker-files/no-end-newline.txt test-format-checker-files/trailing-space.txt test-format-checker-files/more-than-80-chars-line.txt > "$actual" 2>&1
echo -n "../bin/format-checker.sh non-existent-file.txt test-format-checker-files/no-end-newline.txt test-format-checker-files/trailing-space.txt test-format-checker-files/more-than-80-chars-line.txt"
assert "$expected" "$actual"
