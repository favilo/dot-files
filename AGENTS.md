# Dotfiles Ansible — AI Agents

Read `CONVENTIONS.md` before any GitHub or Jujutsu operation.

<!-- BEGIN bigpowers:context-routing -->
## Context Routing

No additional context files exist.
<!-- END bigpowers:context-routing -->

<!-- BEGIN bigpowers:learned-preferences -->
## Learned User Preferences

- The user applies Ansible changes manually.

## Workspace Facts

- Manage this repository exclusively through Jujutsu.
- The protected `main` bookmark requires pull-request integration.
<!-- END bigpowers:learned-preferences -->

<!-- BEGIN bigpowers:project -->
## Project

Use this Ansible project to configure new computers and synchronize personal tool configurations.
Stack: Ansible YAML, Lua, KDL, shell, and tool-specific configuration formats.

## Commands

| Action | Command |
|--------|---------|
| Preview | `just dry-run` |
| Apply | `just apply` — human only |
| Test | `just test` |
| Build | N/A |
| Lint | `just lint` |
| Check | `just check` |
| Format | `just fmt` |
| Preflight | `just test && just lint` |
| CI | `gh pr checks` when a pull request exists |

## Test

Run `just test`.

## Lint

Run `just lint`.

## Build

No build command exists.

## Architecture

Use `dotfiles.yml` as the localhost playbook.
Keep each role's tasks, files, and templates together under `roles/`.
Keep repository utilities under `bin/`.

## Conventions

- Follow existing repository patterns.
- Use Conventional Commits.
- Prefix every Jujutsu bookmark with `favilo/`.
- Preserve Ansible check-mode behavior.

## Never

- NEVER run `just apply`.
- NEVER run `jj restore` on files.
- NEVER move the `main` bookmark directly.
- NEVER use raw Git commands.
- NEVER bypass protected-bookmark pull-request integration.
- NEVER dismiss a reproducible gate failure as pre-existing or irrelevant.
- NEVER continue when Preflight or CI is red.

## Agent Rules

- MUST use bigpowers skills for structured work.
- Read `.specs/` and `CONVENTIONS.md` before writing code.
- Write all planning output under `.specs/`.
- Write the minimum change that solves the stated problem.
- Run relevant tests after every change.
- Show verification evidence before declaring completion.
- Ask one clarifying question instead of encoding an unsupported assumption.
<!-- END bigpowers:project -->
