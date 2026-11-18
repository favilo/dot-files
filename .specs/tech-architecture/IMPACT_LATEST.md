## Target

`roles/nvim` cross-platform Neovim PATH precedence.

## Dependents (3)

- `roles/nvim/tasks/main.yml`: installs Bob and selects the managed Neovim version.
- `roles/zsh/files/zshrc.local`: puts `~/.local/bin` before package-manager paths.
- `roles/zellij/files/zellij-editor`: invokes `nvim` through PATH.

## Affected Stories

- No release-plan story owns Neovim installation management.

## Test Coverage

- No automated installation tests exist.
- `just dry-run` validates Ansible check-mode safety.

## Risk: Low

Bob's active shim supplies Neovim independently of OS package managers.

## Recommended action

Link Bob's active shim into `~/.local/bin` on Linux and macOS; remove the competing Homebrew formula on macOS.
