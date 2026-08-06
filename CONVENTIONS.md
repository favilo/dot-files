# Conventions

## Conventional Commits

Use Conventional Commits for every commit.

Format commit subjects as `<type>(<scope>): <description>`.
Omit the scope only when no precise scope exists.

| Type | Purpose |
|------|---------|
| `feat` | Add behavior or capability |
| `fix` | Correct a defect |
| `refactor` | Restructure without changing behavior |
| `test` | Add or revise tests |
| `docs` | Change documentation |
| `chore` | Maintain tooling or metadata |

NEVER add AI attribution or AI co-author footers.

## Version Control

Use Jujutsu exclusively for version-control operations.
Prefix every Jujutsu bookmark with `favilo/`.
NEVER use raw Git commands.
NEVER move the `main` bookmark directly.
NEVER run `jj restore` on files.
Use a pull request to integrate changes into protected `main`.

## Commands

| Action | Command |
|--------|---------|
| Preview | `just dry-run` |
| Apply | `just apply` — human only |
| Test | `just test` |
| Lint | `just lint` |
| Check | `just check` |
| Format | `just fmt` |
| Preflight | `just test && just lint` |

NEVER run `just apply`.
Run `just dry-run` to preview Ansible changes.
Run `just fmt` only when formatting changes are intended.

## Architecture

Use `dotfiles.yml` as the localhost playbook.
Keep Ansible roles under `roles/`.
Keep each role's tasks, files, and templates beside that role.
Keep repository utilities under `bin/`.
Follow existing organization for tool-specific configuration files.

## Ansible Check-Mode Safety

Preserve `just dry-run` behavior for every Ansible change.
MUST use modules with check-mode support for mutating tasks.
MUST guard unsupported mutating commands during check mode.
MUST mark read-only probes with `changed_when: false`.
MUST limit `check_mode: false` to proven read-only probes.
NEVER let a dry run mutate the configured machine.
Verify Ansible changes with `just dry-run` before requesting manual application.

## Always Green / Shift Left

Keep Preflight and applicable CI checks green before forward work.
Run `just test && just lint` as Preflight.
Run `gh pr checks` when a pull request exists.
Stop forward work when Preflight or CI fails reproducibly.

Fixing defects early reduces integration and production costs.
Treat local verification as the first quality gate.
Treat protected-branch CI as the integration gate.

## Discovered Defects

Treat every reproducible gate failure as a discovered defect.
Use `quick-fix` for trivial data-only defects within its guardrails.
Use `fix-bug` when investigation or code changes are required.
Write a bug specification when reliable reproduction remains blocked.
Stop original forward work until fix-or-log restores green gates.
Keep discovered fixes in separate Conventional Commits.

Agents MUST NOT dismiss reproducible failures with these phrases:

| Banned dismissal | Required response |
|------------------|-------------------|
| Pre-existing issue | Reproduce and fix-or-log |
| Unrelated to this session | Reproduce and fix-or-log |
| Not introduced by my changes | Prove by comparison, then fix-or-log |
| Out of scope | Stop forward work and fix-or-log |

## Tests and Validation

Run relevant tests after every behavior change.
Add regression coverage for every repaired defect when automated coverage exists.
Keep tests fast, independent, repeatable, self-validating, and timely.
Verify observable behavior through public interfaces.
Show command evidence before declaring work complete.

## Planning Output

Write all planning and verification artifacts under `.specs/`.
Use `.specs/state.yaml` for active workflow state.
Use `.specs/product/` for scope, vision, and glossary artifacts.
Use `.specs/epics/` for epic and story plans.
Use `.specs/tech-architecture/` for architecture and quality plans.
Use `.specs/verifications/` for verification evidence.
Use `.specs/bugs/` for defect investigations and registry data.
NEVER pre-create `.specs/state.yaml.lock`.

## Defensive Code

Apply no standard defensive-code category by default.
Evaluate retries and timeouts only when a task introduces unreliable network operations.
Do NOT add rate limits, circuit breakers, or graceful degradation without explicit requirements.
Treat Ansible check-mode safety as the project-specific defensive requirement.
