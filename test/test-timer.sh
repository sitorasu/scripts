#!/bin/bash

source test.sh
alias timer=../timer.sh

check_stdout 'This command requires exactly one argument.' 'timer'
check_stdout 'invalid argument.' 'timer not_a_number'
check_stdout 'invalid argument.' 'timer 12ab'
check_stdout 'invalid argument.' 'timer ab12'
