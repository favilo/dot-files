-- Git / jj integration and GitHub helpers.
return {
  {
    -- GitHub support for fugitive's :GBrowse; only needed once you reach for it.
    "tpope/vim-rhubarb",
    event = "VeryLazy",
  },
  {
    "NeogitOrg/neogit",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("plugins.git")
    end,
  },
  {
    "rafikdraoui/jj-diffconflicts",
    lazy = false,
  },
  -- {
  --   'swaits/lazyjj.nvim',
  --   lazy = false,
  --   dependencies = 'nvim-lua/plenary.nvim',
  --   opts = {
  --     mapping = '<leader>jj'
  --   }
  -- },

  {
    "julienvincent/hunk.nvim",
    cmd = { "DiffEditor" },
    config = function()
      require("hunk").setup()
    end,
  },

  { "lewis6991/gitsigns.nvim" },

  {
    "polarmutex/git-worktree.nvim",
    version = "^2",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("plugins.git_worktree")
    end,
  },
  {
    "almo7aya/openingh.nvim",
    cmd = { "OpenInGHRepo", "OpenInGHFile", "OpenInGHFileLines" },
  },
}
