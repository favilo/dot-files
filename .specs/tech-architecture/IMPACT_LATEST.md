## Target
`roles/programming` lspmux service provisioning.

## Dependents (3)
- `roles/programming/tasks/main.yml`: installs lspmux and currently provisions the systemd unit.
- `roles/programming/templates/lspmux.service.j2`: Linux service definition.
- `roles/nvim/files/lua/plugins/lsp/servers.lua`: configures rust-analyzer to use lspmux.

## Affected Stories
- No release-plan story owns lspmux service management.

## Test Coverage
- No automated service lifecycle tests exist.
- `just dry-run` validates Ansible check-mode safety on macOS.

## Risk: Medium
The service must remain automatically started at login and restarted after failure on three operating-system families, while dry runs must not mutate the host.

## Recommended action
Move Linux service tasks to `after.linux.yml`, add `macos.yml` with a managed LaunchAgent, and verify with `just dry-run` plus the local LaunchAgent state.
