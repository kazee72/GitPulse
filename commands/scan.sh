#!/bin/bash

# scan.sh - Scans a directory and checks if it is a git repository
# Author: Joel Bonini
#
# Changelog:
#   19.03.2026 - initial creation
#   02.04.2026 - Add get_repo_status() with branch, dirty, ahead/behind, stash checks
#   09.04.2026 - Add cmd_scan(), table output with headers

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

get_repo_status() {
    local repo_path="$1"
    local branch
    local name
    name=$(basename "$repo_path")

    if ! git -C "$repo_path" rev-parse HEAD > /dev/null 2>&1; then
        printf "%-20s %-15s %-22s %-8s %-8s %-18s %-8s %-8s\n" "$name" "$branch" "no commits" "-" "-" "-" "0" "0"
        return
    fi

    branch=$(git -C "$repo_path" branch --show-current)
    
    if [ -z "$(git -C "$repo_path" status --porcelain)" ]; then
        local status="clean"
    else
        local status="dirty"
    fi

    if [ "$status" = "clean" ]; then
        status=$(color_green "✓ clean")
    else
        status=$(color_red "✗ dirty")
    fi

    if git -C "$repo_path" rev-parse --abbrev-ref @{u} > /dev/null 2>&1; then
        local ahead=$(git -C "$repo_path" rev-list @{u}..HEAD --count 2>/dev/null)
        local behind=$(git -C "$repo_path" rev-list HEAD..@{u} --count 2>/dev/null)
    else
        local ahead="N/A"
        local behind="N/A"
    fi

    local last_commit=$(git -C "$repo_path" log -1 --format="%cr")

    local stash_count=$(git -C "$repo_path" stash list | wc -l | tr -d ' ')

    local untracked=$(git -C "$repo_path" ls-files --others --exclude-standard | wc -l | tr -d ' ')


    printf "%-20s %-15s %-35s %-8s %-8s %-18s %-8s %-8s\n" "$name" "$branch" "$status" "$ahead" "$behind" "$last_commit" "$stash_count" "$untracked"
}

cmd_scan() {
    local scan_dir="${1:-.}"
    
    printf "%-20s %-15s %-22s %-8s %-8s %-18s %-8s %-8s\n" "REPO" "BRANCH" "STATUS" "AHEAD" "BEHIND" "LAST COMMIT" "STASH" "UNTRACK"
    
    for repo in $(find_repos "$scan_dir"); do
        get_repo_status "$repo"
    done
}