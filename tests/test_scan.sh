#!/bin/bash

# test_scan.sh — Tests for the scan command
# Author: Joel Bonini
#
# Changelog:
#   26.03.2026 - Initial test cases for repo discovery

PASS=0
FAIL=0

assert_contains() {
    local label="$1"
    local output="$2"
    local expected="$3"

    if echo "$output" | grep -q "$expected";
    then
        echo "PASS: $label"
        ((PASS++))
    else
        echo "FAIL: $label"
        ((FAIL++))
    fi
}

tmp_dir=$(mktemp -d)

mkdir "$tmp_dir/real-repo"
git init "$tmp_dir/real-repo"

mkdir "$tmp_dir/also-a-repo"
git init "$tmp_dir/also-a-repo"

mkdir "$tmp_dir/not-a-repo"




rm -rf "$tmp_dir"