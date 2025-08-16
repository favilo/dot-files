local servers = require("plugins.lsp.servers").servers

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and
      vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") ==
      nil
end


local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local luasnip = require("luasnip")

local cmp_mappings = cmp.mapping.preset.insert({
  ['<Tab>'] = nil,
  ['<S-Tab>'] = nil,
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ['<C-space>'] = cmp.mapping.complete(),
  ['<C-e>'] = cmp.mapping.abort(),
  ['<TAB>'] = cmp.mapping(function(fallback)
    -- Supermaven stuff
    -- local suggestion = require('supermaven-nvim.completion_preview')
    -- if suggestion.has_suggestion() then
    --   suggestion.on_accept_suggestion()
    -- Copilot stuff
    local copilot_installed, suggestion = pcall(require, "copilot.suggestion")
    if copilot_installed and suggestion.is_visible() then
      require("copilot.suggestion").accept()
    elseif cmp.visible() then
      cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
    elseif luasnip.expand_or_locally_jumpable() then
      luasnip.expand_or_jump()
    elseif has_words_before() then
      cmp.complete()
    else
      fallback()
    end
  end),
})

cmp.setup({
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  sources = {
    { name = 'copilot' },
    { name = 'nvim_lsp' },
    { name = 'digraphs' },
  },
  mapping = cmp_mappings,
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
})

local capabilities = require("plugins.lsp.servers").capabilities
local lsp_on_attach = require("plugins.lsp.keys").lsp_on_attach

-- LspAttach is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    lsp_on_attach(client, event)
  end,
})

require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {
    'ts_ls',
    'eslint',
    'lua_ls',
    -- rustaceanvim handles this now
    -- 'rust_analyzer',
    'pylsp',
    -- 'basedpyright',
    'clangd',
    'jsonls',
    'yamlls',
    'bashls',
    -- 'cpptools',
    -- 'codelldb',
  },
  automatic_enable = false,
})


-- Setup the LSP servers
-- local lspconfig = require('lspconfig')
for server_name, config in pairs(servers) do
  config.capabilities = capabilities
  if config.on_attach ~= nil then
    config.on_attach = lsp_on_attach
  end

  -- vim.notify("Setting up " .. server_name, vim.log.levels.DEBUG)
  -- vim.notify(vim.inspect(config))
  vim.lsp.config(server_name, config)
end

vim.lsp.enable(vim.tbl_keys(servers))


require("actions-preview").setup {
  highlight_command = {
    require("actions-preview.highlight").diff_so_fancy(),
  },

  backend = { "telescope" },
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
  )
}

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
