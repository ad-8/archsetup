#!/usr/bin/env sh

print_heading() {
    input_string="$*"
    string_length=${#input_string}
    asterisks_line=$(printf '%*s' "$string_length" | tr ' ' '*')

    echo
    echo "$asterisks_line"
    echo "$input_string"
    echo "$asterisks_line"
}

SCRIPT_DIR=$(pwd)
USERNAME="ax"
