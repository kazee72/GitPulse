#!/bin/bash

# test_scan.sh — Tests for the scan command
# Author: Joel Bonini
#
# Changelog:
#   26.03.2026 - Initial test cases for repo discovery
#   02.04.2026 - Add assert_not_contains

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

assert_not_contains() {
    local label="$1"
    local output="$2"
    local expected="$3"

    if echo "$output" | grep -q "$expected";
    then 
        echo "FAIL: $label"
        ((FAIL++))
    else
        echo "PASS: $label"
        ((PASS++))
    fi
}

tmp_dir=$(mktemp -d)

mkdir "$tmp_dir/real-repo"
git init -q "$tmp_dir/real-repo"

mkdir "$tmp_dir/also-a-repo"
git init -q "$tmp_dir/also-a-repo"

mkdir "$tmp_dir/not-a-repo"

output=$(./gitpulse.sh scan "$tmp_dir")
assert_contains "finds git repo" "$output" "real-repo"
assert_contains "finds second git repo" "$output" "also-a-repo"
assert_not_contains "skips non-git repo" "$output" "not-a-repo"

rm -rf "$tmp_dir"

echo ""
echo "Results: $PASS passed, $FAIL failed"