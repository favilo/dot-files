local venv_path = os.getenv('VIRTUAL_ENV')
local py_path = nil

if venv_path ~= nil then
  vim.notify("Found venv at " .. venv_path)
  py_path = venv_path .. '/bin/python'
end

local servers = {
  pylsp = {
    settings = {
      pylsp = {
        plugins = {
          black = { enabled = true },
          rope = { enabled = true },
          pylsp_mypy = {
            enabled = true,
            dmypy = true,
            live_mode = false,
            strict = false,
          },
          pylsp_inlay_hints = {
            enabled = true,
          },
          mypy = {
            enabled = true,
            overrides = { "--python-executable", py_path, true },
            report_progress = true,
          },
          isort = { enabled = true, profile = 'black' },
          autopep8 = { enabled = false },
          yapf = { enabled = false },
          ruff = {
            enabled = false,
            formatEnabled = false,
          },
          pycodestyle = {
            enabled = true,
            maxLineLength = 140,
          },
          pyflakes = { enabled = false },
          mccabe = { enabled = false },
          flake8 = {
            enabled = false,
            ignore = { 'E501' },
            maxLineLength = 140,
          },
        },
      },
    },
  },
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim' },
        },
      },
    },
  },
  rust_analyzer = {
    cmd = vim.lsp.rpc.connect(vim.env.HOME .. "/.local/var/run/ra-mux/ra-mux.sock"),
    settings = {
      ['rust-analyzer'] = {
        lspMux = {
          version = "1",
          method = "connect",
          server = "rust-analyzer",
        },
        assist = {
          importGranularity = "module",
          importPrefix = "by_self",
        },
        checkOnSave = {
          command = "clippy",
        },
        cargo = {
          allFeatures = true,
          loadOutDirsFromCheck = true,
        },
        procMacro = {
          enable = true,
        },
      },
    },
  },
  jsonls = {
    formatting_options = {
      tabSize = 2,
    },
    settings = {
      json = {
        colorDecorators = {
          enable = true,
        },
        format = {
          enable = true,
          keepLines = true,
        },
        validate = {
          enable = true,
        },
        schemaDownload = {
          enable = true,
        },
        schemas = require("schemastore").json.schemas(
        -- {
        --     select = {
        --         "package.json",
        --         ".eslintrc",
        --         "tsconfig.json",
        --         "*.docnav.vson",
        --     },
        -- }
        ),
      },
    },
    -- → json.maxItemsComputed        default: 5000
    -- → json.trace.server            default: "off"
  },
  yamlls = {
    formatting_options = {
      tabSize = 2,
    },
    settings = {
      yaml = {
        schemaStore = {
          enable = false,
          url = "",
        },
        schemas = require("schemastore").yaml.schemas()
      },
    },
  },
}

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
  ['<M-space>'] = cmp.mapping.complete(),
  ['<C-e>'] = cmp.mapping.abort(),
  ['<TAB>'] = cmp.mapping(function(fallback)
    local suggestion = require('supermaven-nvim.completion_preview')
    if suggestion.has_suggestion() then
      suggestion.on_accept_suggestion()
      -- Copilot stuff for if I go back.
      -- if require("copilot.suggestion").is_visible() then
      --     require("copilot.suggestion").accept()
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
    { name = 'supermaven' },
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

local lsp_defaults = require('lspconfig').util.default_config

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
lsp_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lsp_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

-- LspAttach is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = { buffer = event.buf, remap = false }
    local id = vim.tbl_get(event, 'data', 'client_id')
    local client = id and vim.lsp.get_client_by_id(id)
    if client == nil then
      return
    end

    if client.name == "eslint" then
      vim.cmd.LspStop('eslint')
      return
    end

    if client.name == "yamlls" then
      client.server_capabilities.documentFormattingProvider = true
    end
    -- if client.name == "jsonls" then
    --   client.textDocument.completion.snippetSupport = true
    -- end

    vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "<leader>cD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "<leader>ci", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>cl",
      function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }), { bufnr = event.buf })
      end,
      opts)
    vim.keymap.set({ "n", "v" }, "<leader>cws", vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, opts)
    vim.keymap.set({ "v", "n" }, "<leader>ca", require('actions-preview').code_actions, opts)
    vim.keymap.set("n", "<leader>cR", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<leader>cf", function()
      local formatting_options = nil
      if servers[client.name] and servers[client.name].formatting_options then
        formatting_options = servers[client.name].formatting_options
      else
        formatting_options = {}
      end

      local filter = function(local_client)
        vim.print(vim.inspect(local_client.name))
        return true
      end
      vim.lsp.buf.format({
        filter = filter,
        async = true,
        timeout_ms = 10000,
        formatting_options = formatting_options,
      })
    end, opts)
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
  end,
})

require('mason-lspconfig').setup({
  ensure_installed = {
    'ts_ls',
    'eslint',
    'lua_ls',
    'rust_analyzer',
    'pylsp',
    'clangd',
    'jsonls',
    'yamlls',
    -- 'cpptools',
    -- 'codelldb',
  },
  handlers = {
    -- this first function is the "default handler"
    -- it applies to every language server without a "custom handler"
    function(server_name)
      local config = servers[server_name]
      if config == nil then
        config = {}
      end

      config.capabilities = lsp_defaults.capabilities
      if config.on_attach ~= nil then
        config.on_attach = nil
      end

      require('lspconfig')[server_name].setup(config)
    end,
  }
})

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

vim.diagnostic.config({
  virtual_text = true,
})
require('lspconfig').glslls.setup {}

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
