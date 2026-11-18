# Global Agent Instructions

## Shell Commands

- Format separate shell commands on separate lines so humans can review them
  easily. Do not combine commands on one line with semicolons.
- Use the dedicated `read`, `grep`, `find`, and `ls` tools for inspecting
  file contents and searching code. Prefer those over Bash `rg`, `find`,
  `ls`, or `cat` so humans are not prompted for read-only inspection. Use
  Bash only when execution is required.
- Never use Ruby. Use Python only when a task cannot easily be done with simple
  shell commands. For parsing or manipulating YAML, use `yq` exclusively. For
  JSON, use `jq` exclusively. Do not use Python to read JSON or YAML when `jq`
  or `yq` already covers the job.
- Format all scripts for easy human review, including temporary Python or
  TypeScript scripts and scripts used to test TypeScript code. Use readable
  heredoc scripts for one-off Bash commands when a script is needed; the
  restriction on heredocs for `jj` descriptions still applies.

## Version Control

- **Never use `git` on this machine.** Always use **Jujutsu (`jj`)** for all
  version control operations.
- Do not execute raw `git` commands (such as `git commit`, `git checkout`, `git
  branch`, `git push`, `git rebase`, etc.).
- Use the appropriate `jj` workflow commands instead (e.g., `jj status`, `jj
  diff`, `jj describe`, `jj new`, `jj bookmark`, `jj git push`).
- Do not use bash substitutions, heredocs, or `cat` to build commit, describe,
  MR, or PR message bodies. Pass the text as a direct string flag (`-m`, `-d`,
  `--title`), or write a file with the `write` tool and pass `--description-file`
  / `--body-file`. Finish a change with `jj commit -m`, not `jj describe`
  followed by `jj new`. Repeat `-m` for another paragraph.
- For a change summary, use `jj diff --stat`. Do not add `--git` to that command. `--git` prints the full diff and undoes the summary.
- For a line-by-line diff, use `jj diff --git`, without ANSI color codes, so the agent can tell what lines are added and removed. By default, `jj diff` shows side-by-side diffs that are almost impossible for the agents to understand.

## Rust

- Format with `cargo fmt` from the Rust workspace directory. Do not run
  `rustfmt` on individual files.

## Cursor tool discovery

- Never call `GetDynamicTools`. It fails in this Cursor/Pi bridge setup with:
  `Error: Tool pi_tools-GetDynamicTools was not found. Use GetDynamicTools to discover available servers and their tools.`
- Use only the callable tool surfaces listed in the prompt. Prefer `codemode`
  for MCP discovery and calls when that fits the task.
