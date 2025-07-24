return {
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    lazy = false,
    config = function()
      require("plugins.telescope")
    end,
    dependencies = {
      { "nvim-lua/popup.nvim" },
      { "nvim-lua/plenary.nvim" },
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release',
      },

      { "cljoly/telescope-repo.nvim" },
      { "nvim-telescope/telescope-live-grep-args.nvim" },
      -- { "nvim-telescope/telescope-frecency.nvim" },
    },
  },
  {
    'bluz71/vim-nightfly-colors',
    name = 'nightfly',
    lazy = false,
    priority = 1000,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      'IndianBoy42/tree-sitter-just',
    },
    config = function()
      local configs = require('nvim-treesitter.configs')
      vim.filetype.add({
        extension = {
          bean = "beancount",
        }
      })
      configs.setup({
        ensure_installed = { "c", "cpp", "lua", "python", "rust", "javascript", "typescript", "html", "css", "json",
          "yaml", "toml", "bash", "markdown", "beancount" },
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            node_incremental = 'v',
            node_decremental = 'V',
          },
        },
      })
    end,
  },
  {
    "davidmh/mdx.nvim",
    config = true,
    dependencies = { "nvim-treesitter/nvim-treesitter" }
  },
  { 'nvim-treesitter/playground' },
  { 'mbbill/undotree' },
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup {
        -- Methods of detecting the root directory. **"lsp"** uses the native neovim
        -- lsp, while **"pattern"** uses vim-rooter like glob pattern matching. Here
        -- order matters: if one is not detected, the other is used as fallback. You
        -- can also delete or rearangne the detection methods.
        detection_methods = { "pattern", "lsp", },
        patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn" },
        exclude_dirs = { "~/.cargo/*" },

        show_hidden = true,

        -- When set to false, you will get a message when project.nvim changes your
        -- directory.
        silent_chdir = false,

        -- What scope to change the directory, valid options are
        -- * global (default)
        -- * tab
        -- * win
        scope_chdir = 'win',
      }
    end
  },
  {
    'chaoren/vim-wordmotion',
    lazy = false,
  },
  {
    'tpope/vim-rhubarb',
    lazy = false,
  },
  {
    'tpope/vim-surround',
    lazy = false,
  },
  {
    'tpope/vim-commentary',
    lazy = false,
  },
  {
    'tpope/vim-dadbod',
    lazy = false,
  },
  {
    'tpope/vim-dispatch',
    lazy = false,
  },
  {
    'tpope/vim-endwise',
    lazy = false,
  },
  {
    'tpope/vim-speeddating',
    lazy = false,
  },
  {
    'tpope/vim-sensible',
    lazy = false,
  },
  { 'Townk/vim-autoclose' },
  {
    'NeogitOrg/neogit',
    lazy = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      "sindrets/diffview.nvim",
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require("plugins.git")
    end,
  },

  { 'lewis6991/gitsigns.nvim' },

  {
    'polarmutex/git-worktree.nvim',
    version = '^2',
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require('plugins.git_worktree')
    end,
  },

  {
    'saecki/crates.nvim',
    event = { "BufRead Cargo.toml" },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('crates').setup()
    end,
  },

  {
    'williamboman/mason.nvim',
    lazy = false,
    opts = {
      PATH = "prepend",
    },
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    lazy = false,
    cmd = { 'LspInfo', 'LspInstall', 'LspStart', 'LspRestart', 'LspStop' },
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'williamboman/mason.nvim',
      {
        'williamboman/mason-lspconfig.nvim',
        lazy = false,
        -- build = ':PylspInstall python-lsp-black pyls-isort pylsp-rope pylsp-mypy pylint',
      },
      'folke/neodev.nvim',
      'saghen/blink.cmp',
      -- 'mrcjkb/rustaceanvim',
      'b0o/schemastore.nvim',
      "lukas-reineke/lsp-format.nvim",
      'saadparwaiz1/cmp_luasnip',
      -- Snippets
      {
        'L3MON4D3/LuaSnip',
        version = "v2.*",
        build = "make install_jsregexp",
      },
      'rafamadriz/friendly-snippets',
    },
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = true,
        virtual_text = { spacing = 4, prefix = "●" },
        severity_sort = true,
      },
    },
    config = function()
      require('plugins.lsp.config')
      require('plugins.lsp.setup')
    end,
  },

  { 'ray-x/lsp_signature.nvim' },
  { 'aznhe21/actions-preview.nvim' },
  -- use {
  --     'weilbith/nvim-code-action-menu',
  --     cmd = 'CodeActionMenu',
  -- }
  { 'mrjones2014/op.nvim',         build = 'make install' },
  { 'averms/black-nvim',           cmd = 'UpdateRemotePlugins' },

  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  },

  -- { 'simrat39/rust-tools.nvim' },

  { 'nvim-lua/plenary.nvim' },

  { 'nvim-telescope/telescope-project.nvim' },

  {
    "someone-stole-my-name/yaml-companion.nvim",
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      require("plugins.telescope").load_extension("yaml_schema")
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      require("copilot").setup({
        panel = { enabled = true },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          hide_during_completion = true,
          keymap = {
            accept = "<TAB>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        filetypes = {
          yaml = true,
          python = true,
          lua = true,
          rust = true,
          toml = true,
          markdown = true,
        }
      })

      local suggestion = require("copilot.suggestion")
      local function toggle_auto_trigger()
        local auto_trig = vim.b.copilot_suggestion_auto_trigger
        if auto_trig == nil or auto_trig == true then
          vim.notify("Copilot auto-suggestion disabled")
          suggestion.dismiss()
        else
          vim.notify("Copilot auto-suggestion enabled")
          suggestion.next()
        end
        suggestion.toggle_auto_trigger()
      end

      vim.keymap.set({ "i", "n", "v" }, "<A-space>", function() suggestion.toggle_auto_trigger() end,
        { desc = "Toggle auto trigger" })
      vim.keymap.set("n", "<leader>cT", "<cmd>Copilot toggle<CR>", { desc = "Copilot toggle" })
      vim.keymap.set("n", "<leader>cs", toggle_auto_trigger, { desc = "Copilot Suggestion toggle" })
      vim.keymap.set("i", "<C-e>", toggle_auto_trigger, { desc = "Copilot Suggestion toggle" })
    end,
  },
  -- Can't use supermaven for work.
  -- {
  --   "supermaven-inc/supermaven-nvim",
  --   lazy = false,
  --   config = function()
  --     require("supermaven-nvim").setup({
  --       keymap = {
  --         accept_suggestion = "<CR>",
  --         clear_suggestion = "<C-]>",
  --         accept_word = "<C-j>",
  --       },

  --     })
  --   end,
  -- },

  { 'nanotee/zoxide.vim' },

  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("plugins.oil")
    end,
  },

  { 'lambdalisue/fern.vim' },
  { 'lambdalisue/suda.vim' },

  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",

      -- see below for full list of optional dependencies 👇
    },
    lazy = true,
    event = {
      "BufReadPre ~/Obsidian/Main Vault/*.md",
      "BufNewFile ~/Obsidian/Main Vault/*.md",
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/Obsidian/Main Vault",
        },
      },
      -- see below for full list of options 👇
      notes_subdir = "_Resources/Inbox",
      log_level = vim.log.levels.INFO,
      daily_notes = {
        folder = "_Archive/tracking/dailies",
        date_format = "%Y-%m-%d",
        template = "_Resources/templates/daily-update",
        default_tags = { "#daily" },
      },
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },
      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        -- Toggle check-boxes.
        ["<leader>ch"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
      },
    },
  },
  { 'wakatime/vim-wakatime',        lazy = false },

  {
    "epwalsh/pomo.nvim",
    version = "*", -- Recommended, use latest release instead of latest commit
    dependencies = {
      -- Optional, but highly recommended if you want to use the "Default" timer
      "rcarriga/nvim-notify",
    },
    config = function()
      require("pomo").setup({
        -- See below for full list of options 👇
      })
    end,
  },

  -- DAP plugins
  {
    'mfussenegger/nvim-dap',
    lazy = false,
    config = function()
      require('plugins.dap')
    end,
  },
  -- use {
  --     'ldelossa/nvim-dap-projects',
  --     dependencies = { 'mfussenegger/nvim-dap' },
  -- }
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    }
  },

  { 'mfussenegger/nvim-dap-python', dependencies = { "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui" } },
  {
    'almo7aya/openingh.nvim',
    lazy = false,
  },

  -- When I can figure out how to actually use this crap, I'll put it back in. Until then, I'll just use the
  -- built-in LSP, and `Mason` with rust-analyzer.
  -- {
  --   "mrcjkb/rustaceanvim",
  --   version = "^6",
  --   lazy = false,
  --   config = function()
  --     require("plugins.lsp.rust")
  --   end,
  -- },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-plenary",
      "nvim-neotest/neotest-vim-test",
      -- "rouge8/neotest-rust",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter"
    }
  },

  { 'sk1418/HowMuch' },
  { 'diepm/vim-rest-console' },

  -- use { 'airblade/vim-rooter' }
  {
    "hedyhli/outline.nvim",
    lazy = false,
    -- cmd = { "Outline", "OutlineOpen", },
    -- keys = {
    --   { "<leader>o",
    -- },
    config = function()
      -- Example mapping to toggle outline
      vim.keymap.set("n", "<leader>o",
        function() require("outline").toggle({ placement = "topleft", focus_outline = false }) end,
        { desc = "Toggle Outline" })
      vim.keymap.set("n", "<leader>O", function() require("outline").focus_toggle() end, { desc = "Focus Outline" })

      require("outline").setup {
        -- Your setup opts here (leave empty to use defaults)
      }
    end,
  },

  {
    "Vigemus/iron.nvim",
    config = function()
      require("plugins.iron")
    end,
  },
  {
    "smoka7/multicursors.nvim",
    event = "VeryLazy",
    dependencies = {
      'nvimtools/hydra.nvim',
    },
    opts = {},
    cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
    keys = {
      {
        mode = { 'v', 'n' },
        '<Leader>m',
        '<cmd>MCstart<cr>',
        desc = 'Create a selection for selected text or word under the cursor',
      },
    },
  },
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    opts = {
      strategies = {
        -- Change the default chat adapter
        chat = {
          adapter = "copilot",
          model = "gemini-2.5-pro",
        },
        inline = {
          adapter = "copilot",
          model = "gemini-2.5-pro",
        },
        roles = {
          user = "favilo",
        },
        keymaps = {
          send = {
            modes = {
              i = { "<C-CR>", "<C-s>" },
            },
          },
          completion = {
            modes = {
              i = "<C-x>",
            },
          },
        },
      },
      adapters = {
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            schema = {
              model = {
                default = "gemini-2.5-flash-preview",
              },
            },
            env = {
              api_key = "cmd:op read op://Private/GeminiAPI/credential --no-newline",
            },
          })
        end,
      },
      extensions = {
        history = {
          enabled = true,
          opts = {
            keymap = "gh",
            save_chat_keymap = "sc",
            auto_save = false,
            auto_generate_title = true,
            continue_last_chat = false,
            delete_on_clearing_chat = false,
            picker = "snacks",
            enable_logging = false,
            dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
          },
        },
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            make_vars = true,
            make_slash_commands = true,
            show_result_in_chat = true,
          },
        },
      },
      opts = {
        -- Set debug logging
        log_level = "DEBUG",
      },
      keys = {
        {
          "<C-a>",
          "<cmd>CodeCompanionActions<CR>",
          desc = "Open the action palette",
          mode = { "n", "v" },
        },
        {
          "<Leader>a",
          "<cmd>CodeCompanionChat Toggle<CR>",
          desc = "Toggle a chat buffer",
          mode = { "n", "v" },
        },
        {
          "<LocalLeader>a",
          "<cmd>CodeCompanionChat Add<CR>",
          desc = "Add code to a chat buffer",
          mode = { "v" },
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "j-hui/fidget.nvim",                    -- Display status
      "ravitemer/codecompanion-history.nvim", -- Save and load conversation history
      {
        "ravitemer/mcphub.nvim",              -- Manage MCP servers
        cmd = "MCPHub",
        build = "npm install -g mcp-hub@latest",
        config = true,
      },
    },
  },
  {
    "nextmn/vim-yaml-jinja",
    lazy = false,
  },
}
