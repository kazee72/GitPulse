#!/bin/bash

# scan.sh - Scans a directory and checks if it is a git repository
# Author: Joel Bonini
#
# Changelog:
#   19.03.2026 - initial creation

find_repos() {
    scan_dir="${1:-.}"

    if [ ! -d "$scan_dir" ];
    then
        echo "Error: Path does not exist: $scan_dir" >&2
        return 1
    fi

    for dir in "$scan_dir"/*
    do
        if is_git_repo "$dir"
        then
            echo "$dir"
        fi
    done
}