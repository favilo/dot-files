## Target
`roles/nvim` macOS installation and PATH precedence.

## Dependents (3)
- `roles/nvim/tasks/main.yml`: installs Bob and selects the managed Neovim version.
- `roles/zsh/files/zshrc.local`: puts `~/.local/bin` before Homebrew on PATH.
- `roles/zellij/files/zellij-editor`: invokes `nvim` through PATH.

## Affected Stories
- No release-plan story owns Neovim installation management.

## Test Coverage
- No automated installation tests exist.
- `just dry-run` validates Ansible check-mode safety and previews Homebrew removal.

## Risk: Low
No installed Homebrew formula depends on Neovim, and Bob's active shim runs Neovim successfully.

## Recommended action
Remove the Homebrew Neovim formula only on macOS and link Bob's active shim into `~/.local/bin`.
