# Repo-wide tasks. Default hooks only check; formatting is opt-in.

# Auto-format everything in place (stylua, shfmt, prettier, whitespace/EOF).
fmt:
    prek run --hook-stage manual --all-files

# Run the check-only hooks against all files (reports errors, no changes).
check:
    prek run --all-files
