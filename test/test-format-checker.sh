#!/bin/bash

source test.sh
source ../format-checker-functions.sh

check_stdout 9 'count_chars_in_line abcdefghi'
check_stdout 9 'count_chars_in_line "  ab  c  "'
check_stdout 9 'count_chars_in_line "あいうabc"'
check_stdout 0 'count_chars_in_line ""'
check_stdout 5 'count_chars_in_line "     "'
check_stdout 5 'count_chars_in_line '\''$hoge'\'
check_stdout 5 'count_chars_in_line '\''*hoge'\'
check_stdout 8 'count_chars_in_line hoge.txt'
check_stdout 10 'count_chars_in_line '\''// /* */ #'\'''
check_stdout 80 'count_chars_in_line 12345678901234567890123456789012345678901234567890123456789012345678901234567890'
check_stdout 80 'count_chars_in_line ああああああああああああああああああああああああああああああああああああああああ'
check_stdout 96 'count_chars_in_line あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをん！？'
