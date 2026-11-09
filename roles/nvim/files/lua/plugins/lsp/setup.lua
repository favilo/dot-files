local servers = require("plugins.lsp.servers").servers

-- Completion is handled by blink.cmp (see lua/plugins/spec/lsp.lua).
local capabilities = require("plugins.lsp.servers").capabilities
local lsp_on_attach = require("plugins.lsp.keys").lsp_on_attach

-- LspAttach is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  group = vim.api.nvim_create_augroup("my.lsp", {}),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    lsp_on_attach(client, event)
  end,
})

require("mason").setup()

local mason_registry = require("mason-registry")

local function install_mdformat_gfm(pkg)
  local pip = pkg:get_install_path() .. "/venv/bin/pip"
  vim.system({ pip, "install", "mdformat-gfm" }, { text = true }, function(result)
    if result.code ~= 0 then
      vim.schedule(function()
        vim.notify("mdformat-gfm install failed:\n" .. (result.stderr or ""), vim.log.levels.ERROR)
      end)
    end
  end)
end

mason_registry:on("package:install:success", function(pkg)
  if pkg.name == "mdformat" then
    install_mdformat_gfm(pkg)
  end
end)

-- mason-lspconfig only accepts lspconfig server names. mdformat is a formatter,
-- so it is installed from this same list through the registry instead.
local ensure_installed = {
  "ts_ls",
  "eslint",
  "lua_ls",
  -- rustaceanvim handles this now
  -- 'rust_analyzer',
  "pylsp",
  -- 'basedpyright',
  "clangd",
  "jsonls",
  "yamlls",
  "bashls",
  -- 'cpptools',
  -- 'codelldb',
  "mdformat",
}
local mason_tools = { mdformat = true }
local lsp_servers = vim.tbl_filter(function(name)
  return not mason_tools[name]
end, ensure_installed)

local function ensure_mason_tool(name)
  local ok, pkg = pcall(mason_registry.get_package, name)
  if not ok then
    vim.notify("Mason package not found: " .. name, vim.log.levels.WARN)
    return
  end
  if not pkg:is_installed() then
    pkg:install()
    return
  end
  if name ~= "mdformat" then
    return
  end
  local python = pkg:get_install_path() .. "/venv/bin/python"
  vim.system({ python, "-c", "import mdformat_gfm" }, { text = true }, function(result)
    if result.code ~= 0 then
      install_mdformat_gfm(pkg)
    end
  end)
end

for name in pairs(mason_tools) do
  ensure_mason_tool(name)
end

require("mason-lspconfig").setup({
  ensure_installed = lsp_servers,
  automatic_enable = false,
})

-- Setup the LSP servers
-- local lspconfig = require('lspconfig')
for server_name, config in pairs(servers) do
  config.capabilities = capabilities

  -- vim.notify("Setting up " .. server_name, vim.log.levels.DEBUG)
  -- vim.notify(vim.inspect(config))
  vim.lsp.config(server_name, config)
  vim.lsp.enable(server_name)
end

-- vim.lsp.enable(vim.tbl_keys(servers))

require("actions-preview").setup({
  highlight_command = {
    require("actions-preview.highlight").diff_so_fancy(),
  },

  backend = { "telescope" },
  diff = {
    algorithm = "patience",
    ignore_whitespace = true,
  },
  telescope = vim.tbl_extend(
    "force",
    -- telescope theme: https://github.com/nvim-telescope/telescope.nvim#themes
    require("telescope.themes").get_dropdown(),
    -- a table for customizing content
    {
      -- a function to make a table containing the values to be displayed.
      -- fun(action: Action): { title: string, client_name: string|nil }
      make_value = nil,

      -- a function to make a function to be used in `display` of a entry.
      -- see also `:h telescope.make_entry` and `:h telescope.pickers.entry_display`.
      -- fun(values: { index: integer, action: Action, title: string, client_name: string }[]): function
      make_make_display = nil,
    }
  ),
})

-- This handles a bug in nvim that causes it to crash when it sends a server cancelation
for _, method in ipairs({ "textDocument/diagnostic", "workspace/diagnostic" }) do
  local default_diagnostic_handler = vim.lsp.handlers[method]
  vim.lsp.handlers[method] = function(err, result, context, config)
    if err ~= nil and err.code == -32802 then
      return
    end
    return default_diagnostic_handler(err, result, context, config)
  end
end
