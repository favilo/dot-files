M = {}

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
          isort = {
            enabled = true,
            profile = 'black'
          },
          autopep8 = { enabled = false },
          yapf = { enabled = false },
          ruff = {
            enabled = false,
            formatEnabled = false,
          },
          pylint = {
            enabled = true,
            -- args = { '--rcfile', '.pylintrc' },
            args = {},
          },
          pycodestyle = {
            enabled = false,
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
  -- rustaceanvim handles it now
  -- rust_analyzer = {
  --   cmd = vim.lsp.rpc.connect(vim.env.HOME .. "/.local/var/run/ra-mux/ra-mux.sock"),
  --   settings = {
  --     ['rust-analyzer'] = {
  --       lspMux = {
  --         version = "1",
  --         method = "connect",
  --         server = "rust-analyzer",
  --       },
  --       assist = {
  --         emitMustUse = true,
  --       },
  --       checkOnSave = true,
  --       check = {
  --         command = "clippy",
  --       },
  --       cargo = {
  --         allFeatures = true,
  --       },
  --       completion = {
  --         autoself = {
  --           enable = true,
  --         },
  --       },
  --       procMacro = {
  --         enable = true,
  --       },
  --     },
  --   },
  -- },
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
  glslls = {},
  ts_ls = {
    filetypes = { 'typescript', 'typescriptreact', 'typescript.tsx', 'javascript', 'javascriptreact', 'javascript.jsx', 'svelte' },
  },
  bashls = {
    filetypes = { 'sh', 'zsh', 'bash', },
  },
}
M.servers = servers

local capabilities = require('blink.cmp').get_lsp_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  },
}
M.capabilities = capabilities

return M
