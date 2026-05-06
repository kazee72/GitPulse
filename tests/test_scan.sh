#!/bin/bash

# test_scan.sh — Tests for the scan command
# Author: Joel Bonini
#
# Changelog:
#   26.03.2026 - Initial test cases for repo discovery
#   02.04.2026 - Add assert_not_contains
#   09.04.2026 - Expand fixtures (dirty, clean, stash, untracked), add status tests
#   16.04.2026 - Add full test suite: status checks, edge cases, CLI tests (20 total)

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

# --- Fixtures ---
tmp_dir=$(mktemp -d)

# normal repos
mkdir "$tmp_dir/real-repo"
git init -q "$tmp_dir/real-repo"

mkdir "$tmp_dir/also-a-repo"
git init -q "$tmp_dir/also-a-repo"

# not a repo
mkdir "$tmp_dir/not-a-repo"

# empty repo (no commits)
mkdir "$tmp_dir/empty-repo"
git init -q -b main "$tmp_dir/empty-repo"

# empty dir
mkdir "$tmp_dir/empty-dir"

# dirty repo
mkdir "$tmp_dir/dirty-repo"
git init -q "$tmp_dir/dirty-repo"
touch "$tmp_dir/dirty-repo/file.txt"
git -C "$tmp_dir/dirty-repo" add .
git -C "$tmp_dir/dirty-repo" commit -q -m "init"
echo "change" >> "$tmp_dir/dirty-repo/file.txt"

# clean repo
mkdir "$tmp_dir/clean-repo"
git init -q -b main "$tmp_dir/clean-repo"
touch "$tmp_dir/clean-repo/file.txt"
git -C "$tmp_dir/clean-repo" add .
git -C "$tmp_dir/clean-repo" commit -q -m "init"

# untracked files
mkdir "$tmp_dir/untracked-repo"
git init -q "$tmp_dir/untracked-repo"
touch "$tmp_dir/untracked-repo/file.txt"
git -C "$tmp_dir/untracked-repo" add .
git -C "$tmp_dir/untracked-repo" commit -q -m "init"
touch "$tmp_dir/untracked-repo/newfile.txt"

# repo with stash
mkdir "$tmp_dir/stash-repo"
git init -q "$tmp_dir/stash-repo"
touch "$tmp_dir/stash-repo/file.txt"
git -C "$tmp_dir/stash-repo" add .
git -C "$tmp_dir/stash-repo" commit -q -m "init"
echo "stash me" >> "$tmp_dir/stash-repo/file.txt"
git -C "$tmp_dir/stash-repo" stash -q


# --- Repo discovery and status tests ---
output=$(./gitpulse.sh scan "$tmp_dir")

dirty_line=$(echo "$output" | grep "dirty-repo")
clean_line=$(echo "$output" | grep "clean-repo")
stash_line=$(echo "$output" | grep "stash-repo")
untracked_line=$(echo "$output" | grep "untracked-repo")
empty_repo_line=$(echo "$output" | grep "empty-repo")

assert_contains "finds git repo" "$output" "real-repo"
assert_contains "finds second git repo" "$output" "also-a-repo"
assert_not_contains "skips non-git repo" "$output" "not-a-repo"

assert_contains "dirty repo shows as dirty"       "$dirty_line"      "dirty"
assert_contains "clean repo shows as clean"       "$clean_line"      "clean"
assert_contains "stash repo shows stash count 1"  "$stash_line"      " 1 "
assert_contains "untracked repo shows 1 untrack"  "$untracked_line"  " 1"
assert_contains "empty repo shows no commits"     "$empty_repo_line" "no commits"
assert_contains "clean repo shows 0 untracked"    "$clean_line"      " 0"
assert_contains "dirty repo shows 0 stash"        "$dirty_line"      " 0"
assert_contains "shows main branch name"          "$clean_line"      "main\|master"
assert_not_contains "output has no fatal errors"  "$output"          "fatal"

# --- Edge case tests ---
empty_output=$(./gitpulse.sh scan "$tmp_dir/empty-dir")
assert_not_contains "empty dir shows no clean repos" "$empty_output" "clean"
assert_not_contains "empty dir shows no dirty repos" "$empty_output" "dirty"

missing_output=$(./gitpulse.sh scan /totally/fake/path 2>&1)
assert_contains "non-existent path shows error" "$missing_output" "does not exist"

# --- CLI flag tests ---
help_output=$(./gitpulse.sh --help)
assert_contains "help flag shows usage" "$help_output" "Usage"

version_output=$(./gitpulse.sh --version)
assert_contains "version flag shows version" "$version_output" "GitPulse"

short_help=$(./gitpulse.sh -h)
assert_contains "short help flag works" "$short_help" "Usage"

short_version=$(./gitpulse.sh -v)
assert_contains "short version flag works" "$short_version" "GitPulse"

unknown_output=$(./gitpulse.sh nonsense 2>&1)
assert_contains "unknown command shows error" "$unknown_output" "Unknown"

# --- Cleanup ---
rm -rf "$tmp_dir"

# --- Summary ---
echo ""
echo "Results: $PASS passed, $FAIL failed"