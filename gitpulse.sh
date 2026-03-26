#!/bin/bash

# gitpulse.sh - main entry point
# Author: Joel Bonini
#
# Changelog:
#   19.03.2026 - inital creation

set -euo pipefail

VERSION="0.1.0"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

source "$SCRIPT_DIR/lib/utils.sh"

show_help() {
    cat <<- EOF
    GitPulse v$VERSION
    Usage: gitpulse <command> [options]

    Commands:
        scan    Scan directories for git repositories

    Run 'gitpulse <command> --help' for more information.
EOF
}

show_version() {
    echo "GitPulse v$VERSION"
}

main() {

    local cmd="${1:-scan}"
    [ $# -gt 0 ] && shift

    case "$cmd" in 
        scan)
            source "$SCRIPT_DIR/commands/scan.sh"
            find_repos "$@"
            ;;
        --help|-h)
            show_help
            ;;

        --version|-v)
            show_version
            ;;

        *)
            echo "Unknown command"
            ;;
    esac
}

main "$@"