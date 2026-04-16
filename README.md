# GitPulse

Monitor the heartbeat of all your Git repos from a single command.

GitPulse is a bash CLI tool that scans a directory for Git repositories and reports their health — dirty/clean state, current branch, unpushed/unpulled commits, last activity, stash count, and untracked files.

## Usage
```bash
./gitpulse.sh scan ~/projects
```

### Commands

- `scan [path]` — scan a directory for git repos and show a status table
- `--help`, `-h` — show usage information
- `--version`, `-v` — show version

## Cron Setup

Run GitPulse automatically twice a day: