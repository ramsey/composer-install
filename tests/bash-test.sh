#!/usr/bin/env bash
#
# bash-test - Simple test runner for Bash
# https://github.com/campanda/bash-test
#
# Copyright (c) 2017 Campanda GmbH
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

function parse_opt {
  case $1 in
    h)
      display_help
      exit 0
      ;;
    v)
      echo "$version"
      exit 0
      ;;
    \?)
      echo -e "Invalid option: -$OPTARG\n"
      display_help
      exit 1
      ;;
  esac
}

function display_help {
  echo -e "Usage: bash-test file1 file2...\n"
  echo -e "Options:\n"
  echo -e "\t-h\tShows this help"
  echo -e "\t-v\tShows version\n"
}

function check_input_files {
  for file in "$@"; do
    test -f "$file" || { display_error_message "$file"; exit 1; }
  done
}

function display_header {
  echo -e "\033[34mbash-test $version by Campanda GmbH and contributors.\033[0m\n"
}

function display_error_message {
  echo -e "\033[31mERROR:\033[0m Invalid input file -> \033[33m$1\033[0m\n"
}

function get_loaded_tests {
  declare -F | cut -d' ' -f3 | grep "^test_"
}

function run_test {
  ((amount_of_tests++))

  $1
  result=$?

  [ $result -ne 0 ] && ((failed_tests++))
  display_test_result $result "$1"
}

function display_test_result {
  [ "$1" -eq 0 ] && echo -e "  \033[32m✓ $2\033[0m" || echo -e "  \033[31m✗ $2\033[0m"
}

function get_loaded_data_providers {
  (set -o posix ; set) | grep "^data_provider_for" | cut -d'=' -f1
}

function display_summary {
  if [ "$failed_tests" -gt 0 ]; then
    echo -e "\033[30;41m $failed_tests of $amount_of_tests tests failed.\033[0m"
  else
    echo -e "\033[30;42m $amount_of_tests tests completed.\033[0m"
  fi
}

version="v0.3.0"
amount_of_tests=0
failed_tests=0

while getopts ":hv" opt; do
  parse_opt "$opt"
done

check_input_files "$@"

time {
  display_header

  original_path=$PATH

  for test_file in "$@"; do
    # shellcheck source=/dev/null
    source "$test_file"
    basename "$test_file"

    if [ -n "$SOURCE" ]; then
      add_to_path="$(dirname "$test_file")/$SOURCE"
      PATH=$add_to_path:$original_path
    fi

    if [[ "$(type -t before)" == "function" ]]; then
      before
    fi

    test_names=$(get_loaded_tests)

    for test_name in $test_names; do
      run_test "$test_name"
    done

    for data_provider in $(get_loaded_data_providers); do
      test_name=${data_provider#data_provider_for}

      while read -r args; do
        run_test "$test_name $args"
      done < "${!data_provider}"
      unset -v "$data_provider"
    done

    if [[ "$(type -t after)" == "function" ]]; then
      after
    fi

    PATH=$original_path
    # shellcheck disable=SC2086
    unset -f $test_names
    unset -v SOURCE

    echo ""
  done

  display_summary
}

exit $failed_tests
