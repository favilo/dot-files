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
        build =
        'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
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
    build = ':TSUpdate'
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
      PATH = "append",
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
    cmd = { 'LspInfo', 'LspInstall', 'LspStart', 'LspRestart', 'LspStop' },
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'williamboman/mason.nvim' },
      {
        'williamboman/mason-lspconfig.nvim',
        build = ':PylspInstall python-lsp-black pyls-isort pylsp-rope pylsp-mypy',
      },
      { 'b0o/schemastore.nvim' },
      { "lukas-reineke/lsp-format.nvim" },
      { 'saadparwaiz1/cmp_luasnip' },
      -- Snippets
      {
        'L3MON4D3/LuaSnip',
        version = "v2.*",
        build = "make install_jsregexp",
      },
      { 'rafamadriz/friendly-snippets' },
    },
  },
  -- {
  --     'VonHeikemen/lsp-zero.nvim',
  --     dependencies = {
  --         -- LSP Support
  --         { 'neovim/nvim-lspconfig' },
  --         { 'williamboman/mason.nvim' },
  --         {
  --             'williamboman/mason-lspconfig.nvim',
  --             build = ':PylspInstall python-lsp-black pyls-isort pylsp-rope',
  --         },
  --
  --         -- Autocompletion
  --         { 'hrsh7th/cmp-buffer' },
  --         { 'hrsh7th/cmp-path' },
  --         { 'hrsh7th/cmp-nvim-lua' },
  --
  --
  --         -- LSP Extras
  --     }
  -- },

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

  { 'simrat39/rust-tools.nvim' },

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
      require("telescope").load_extension("yaml_schema")
    end,
  },
  {
    "supermaven-inc/supermaven-nvim",
    lazy = false,
    config = function()
      require("supermaven-nvim").setup({
        keymap = {
          accept_suggestion = "<CR>",
          clear_suggestion = "<C-]>",
          accept_word = "<C-j>",
        },

      })
    end,
  },

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
  { 'folke/neodev.nvim' },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    }
  },

  { 'mfussenegger/nvim-dap-python', dependencies = { "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui" } },
  { 'almo7aya/openingh.nvim' },

  -- When I can figure out how to actually use this crap, I'll put it back in. Until then, I'll just use the
  -- built-in LSP, and `Mason` with rust-analyzer.
  -- {
  --   "mrcjkb/rustaceanvim",
  --   version = "^5",
  --   lazy = false,
  --   config = function()
  --     vim.g.rustaceanvim = function()
  --       -- Update this path
  --       local codelldb = require('mason-registry').get_package('codelldb')
  --       local extension_path = codelldb:get_install_path() .. '/extension/'
  --       local codelldb_path = extension_path .. 'adapter/codelldb'
  --       local liblldb_path = extension_path .. 'lldb/lib/liblldb'
  --       local this_os = vim.uv.os_uname().sysname;
  --
  --       -- The path is different on Windows
  --       if this_os:find "Windows" then
  --         codelldb_path = extension_path .. "adapter\\codelldb.exe"
  --         liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
  --       else
  --         -- The liblldb extension is .so for Linux and .dylib for MacOS
  --         liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
  --       end
  --
  --       local cfg = require('rustaceanvim.config')
  --       return {
  --         crate_graph = {
  --           backend = "svg",
  --           output = "target/crate-graph.svg",
  --         },
  --         server = {
  --           ra_multiplex = {
  --             enable = true,
  --           },
  --         },
  --         dap = {
  --           adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
  --         },
  --       }
  --     end
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
}
