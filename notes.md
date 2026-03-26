## 19.03.2026
- Scan git Repos by checking for a .git folder
- find_repos() loops through a project directory to find all git repos
- is_git_repo() checks for .git folder
- Errors go to stderr

## 26.03.2026
- Built main entry point gitpulse.sh
- Made help function and used heredoc cat << EOF...EOF for cleaner code
- Added case for subcommand dispatch
- SCRIPT_DIR gives us an absolute path for sourcing files later in the code
- Shifted argument after using and input verifying first argument (see if it exists and give it a default if not)
- Source the command files only when they are needed
