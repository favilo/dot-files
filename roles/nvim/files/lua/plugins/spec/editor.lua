-- Editor UX: finder, colorscheme, treesitter, motions, tpope/*, testing, etc.
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
      { 'jsongerber/telescope-ssh-config' },
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
    branch = "main",
    build = ':TSUpdate',
    dependencies = {
      'IndianBoy42/tree-sitter-just',
    },
    lazy = false,
    config = function()
      require("plugins.treesitter")
      -- local configs = require('nvim-treesitter.configs')
      require('nvim-treesitter').setup({
        ensure_installed = { "c",
          "cpp", "lua", "python", "rust", "javascript", "typescript", "html", "css", "json",
          "yaml", "toml", "bash", "markdown", "markdown_inline", "beancount", },
      })
    end,
  },
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
    event = "VeryLazy",
  },
  {
    'tpope/vim-surround',
    event = "VeryLazy",
  },
  {
    'tpope/vim-dadbod',
    cmd = "DB",
  },
  {
    'tpope/vim-dispatch',
    cmd = { "Dispatch", "Make", "Focus", "Start", "Spawn" },
  },
  {
    'tpope/vim-endwise',
    event = "InsertEnter",
  },
  {
    'tpope/vim-speeddating',
    event = "VeryLazy",
  },
  {
    -- vim-sensible applies baseline defaults at startup, so it must load eagerly.
    'tpope/vim-sensible',
    lazy = false,
  },
  {
    'justinmk/vim-sneak',
    event = "VeryLazy",
  },
  { 'Townk/vim-autoclose' },
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
  { 'nvim-telescope/telescope-project.nvim' },
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
}
