# GitPulse

Monitor the heartbeat of all your Git repos from a single command.

GitPulse is a bash CLI tool that scans a directory for Git repositories and reports their health, dirty/clean state, current branch, unpushed/unpulled commits, last activity, stash count, and untracked files.

## Usage
```bash
./gitpulse.sh scan ~/projects
```

### Commands

- `scan [path]` - scan a directory for git repos and show a status table
- `--help`, `-h` - show usage information
- `--version`, `-v` — show version

## Cron Setup

Run GitPulse automatically twice a day:

30 7,16 * * * /path/to/gitpulse.sh scan /path/to/projects >> /path/to/gitpulse.log 2>&1

## Tests
```bash
bash tests/test_scan.sh
```

## Author

Joel Bonini — M122 Project, 2026