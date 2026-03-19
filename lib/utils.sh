#!/bin/bash

# utils.sh - Shared utility functions
# Author: Joel Bonini
#
# Changelog:
#   19.03.2026 - initial creation with is_git_repo function

set -euo pipefail


is_git_repo() {
    [ -d "$1/.git" ]
}

