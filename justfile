# Repo-wide tasks. Default hooks only check; formatting is opt-in.

mod nvim 'roles/nvim/files'

# Auto-format in place. Pass a hook id to run just that one, e.g. `just fmt stylua-github`.
fmt HOOK="":
    prek run --hook-stage manual {{ HOOK }} --all-files

# Run check-only hooks (no changes). Pass a hook id to run just that one, e.g. `just check shellcheck`.
check HOOK="":
    prek run {{ HOOK }} --all-files

# Run the nvim regression test suite (boots a real nvim headless).
test:
    just nvim test

# Run the code linters: YAML (yamllint) + Ansible (ansible-lint) + Lua
# (lua-language-server + selene). Orthogonal to `check` (prek format/syntax
# hooks); CI runs both.
lint: lint-yaml lint-ansible
    just nvim lint

# Lint YAML with yamllint (config: .yamllint).
lint-yaml DIR=".":
    uvx yamllint {{ DIR }}

# Lint the Ansible playbook and roles with ansible-lint (config: .ansible-lint).
lint-ansible:
    uvx ansible-lint
