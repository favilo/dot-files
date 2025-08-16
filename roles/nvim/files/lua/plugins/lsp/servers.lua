M = {}

local home_path = os.getenv('HOME')
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
            dmypy = false,
            live_mode = true,
            strict = true,
          },
          pylsp_inlay_hints = {
            enabled = true,
          },
          pyright = {
            enabled = true,
            typeCheckingMode = "on",
            useLibraryCodeForTypes = false,
            disableLanguageServices = false,
            disableOrganizeImports = false,
            diagnosticSeverityOverrides = {
              -- reportGeneralTypeIssues = 'none',
              -- reportMissingImports = 'none',
              -- reportImportCycles = 'none',
              -- reportUnusedImport = 'none',
              -- reportUnusedClass = 'none',
              -- reportUnusedFunction = 'none',
              -- reportUnusedVariable = 'none',
              -- reportUnnecessaryComparison = 'none',
              -- reportUnnecessaryIsInstance = 'none',
              -- reportUnnecessaryCast = 'none',
              reportExplicitAny = 'none',
            },
          },
          mypy = {
            enabled = false,
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
            enabled = true,
            formatEnabled = false,
          },
          pylint = {
            enabled = false,
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

  -- basedpyright = {
  --   settings = {
  --     basedpyright = {
  --       analysis = {
  --         autoSearchPaths = true,
  --         diagnosticMode = "workspace",
  --         useLibraryCodeForTypes = false,
  --         disableLanguageServices = false,
  --         disableOrganizeImports = false,
  --         diagnosticSeverityOverrides = {
  --           -- reportGeneralTypeIssues = 'none',
  --           -- reportMissingImports = 'none',
  --           -- reportImportCycles = 'none',
  --           -- reportUnusedImport = 'none',
  --           -- reportUnusedClass = 'none',
  --           -- reportUnusedFunction = 'none',
  --           -- reportUnusedVariable = 'none',
  --           -- reportUnnecessaryComparison = 'none',
  --           -- reportUnnecessaryIsInstance = 'none',
  --           -- reportUnnecessaryCast = 'none',
  --           reportExplicitAny = 'none',
  --         },
  --       },
  --     },
  --   },
  -- },

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
  rust_analyzer = {
    cmd = { "ra-multiplex", "client" },
    -- cmd = { "rust-analyzer" },
    -- cmd = vim.lsp.rpc.connect("/var/run/ra-mux/ra-mux.socket"),

    -- filetypes = { 'rust' },
    -- root_markers = { 'Cargo.toml', 'Cargo.lock' },
    settings = {
      ['rust-analyzer'] = {
        lspMux = {
          version = "1",
          method = "connect",
          server = "rust-analyzer",
          env = { PATH = home_path .. "/.cargo/bin", CARGO_TARGET_DIR = home_path .. "/.cargo/target" },
        },
        -- server = {
        -- },
        installCargo = false,
        installRustc = false,
        assist = {
          emitMustUse = true,
        },
        checkOnSave = {
          enable = true,
          -- extraArgs = { "--target-dir", "./target/check" },
        },
        check = {
          command = "clippy",
        },
        cargo = {
          allFeatures = false,
        },
        completion = {
          autoself = {
            enable = true,
          },
        },
        procMacro = {
          enable = true,
          -- ignored = {
          --   bevy_simple_subsecond_system_macros = { "hot" },
          -- },
        },
        files = {
          exclude = { ".direnv", "target" }
        }
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

  glslls = {},

  ts_ls = {
    filetypes = { 'typescript', 'typescriptreact', 'typescript.tsx', 'javascript', 'javascriptreact', 'javascript.jsx', 'svelte' },
  },

  bashls = {
    filetypes = { 'sh', 'zsh', 'bash', },
  },

  beancount = {
    filetypes = { 'beancount', 'bean' },
    init_options = {
      journal_file = "~/git/finance/oberlies-family/main.bean",
    },
    flags = {
      debounce_text_changes = 500,
    },
  },
  graphql = {
    filetypes = { 'graphql', 'gql' },
  },
  ["jinja_lsp"] = {
    filetypes = { 'jinja', 'yaml-jinja', 'yaml.jinja', },
  },
  copilot = {
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
