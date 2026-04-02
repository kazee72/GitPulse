| #  | Test                    | Description                                      | Expected Result                  | Actual Result | Pass/Fail |
|----|-------------------------|--------------------------------------------------|----------------------------------|---------------|-----------|
| 1  | finds git repo          | Scan directory containing a git repo             | Output contains "real-repo"      |               |           |
| 2  | finds second git repo   | Scan directory with multiple git repos           | Output contains "also-a-repo"    |               |           |
| 3  | skips non-git repo      | Scan directory with a plain folder (no .git)     | Output does NOT contain "not-a-repo" |           |           |