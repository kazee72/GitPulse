#!/bin/bash

# utils.sh - Shared utility functions
# Author: Joel Bonini
#
# Changelog:
#   19.03.2026 - initial creation with is_git_repo function
#   02.04.2026 - Add color functions, logging, die(), require_command()

is_git_repo() {
    [ -d "$1/.git" ]
}

if [[ -t 1 ]]; then
    color_green() { echo -e "\033[0;32m$1\033[0m"; }
    color_red() { echo -e "\033[0;31m$1\033[0m"; }
    color_yellow() { echo -e "\033[0;33m$1\033[0m"; }
    color_blue() { echo -e "\033[0;34m$1\033[0m"; }
    color_dim() { echo -e "\033[0;90m$1\033[0m"; }
    color_bold() { echo -e "\033[1m$1\033[0m"; }
else
    color_green() { echo "$1"; }
    color_red() { echo "$1"; }
    color_yellow() { echo "$1"; }
    color_blue() { echo "$1"; }
    color_dim() { echo "$1"; }
    color_bold() { echo "$1"; }
fi

log_info() {
    color_blue "[INFO] $1"
}

log_warn() {
    color_yellow "[WARN] $1"
}

log_err() {
    color_red "[ERROR] $1" >&2 
}

die() {
    log_err "$1"
    exit 1
}

require_command() {
    if ! command -v "$1" > /dev/null; then
        die "$1 is required but not installed"
    fi
}