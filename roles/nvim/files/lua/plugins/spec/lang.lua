-- Language-specific plugins (filetypes, formatters, language servers, etc.).
local home_dir = os.getenv("HOME")

return {
  {
    "davidmh/mdx.nvim",
    config = true,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("crates").setup()
    end,
  },
  { "averms/black-nvim", cmd = "UpdateRemotePlugins" },
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",

      -- see below for full list of optional dependencies 👇
    },
    lazy = true,
    -- NOTE: autocmd patterns do not expand `~`, so the home dir must be
    -- spelled out or the event never matches and the plugin never loads.
    event = {
      "BufReadPre " .. home_dir .. "/Obsidian/Main Vault/*.md",
      "BufNewFile " .. home_dir .. "/Obsidian/Main Vault/*.md",
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
      legacy_commands = false, -- disable if you don't use Obsidian's in-process LSP or want to implement your own keymaps
      log_level = vim.log.levels.INFO,
      daily_notes = {
        folder = "_Archive/tracking/dailies",
        date_format = "%Y-%m-%d",
        template = "_Resources/templates/daily-update",
        default_tags = { "#daily" },
      },
      -- Completion flows through blink's `lsp` source via obsidian's in-process LSP.
      completion = {
        min_chars = 2,
      },
      -- The `mappings` opt was removed in the obsidian-nvim fork. Native `gf`
      -- already follows wiki-links via the buffer's includeexpr (the old
      -- gf_passthrough behavior, with go-to-file fallback); <CR> is the default
      -- smart_action. Only the custom checkbox toggle needs a per-note keymap.
      callbacks = {
        enter_note = function()
          vim.keymap.set(
            "n",
            "<leader>ch",
            "<cmd>Obsidian toggle_checkbox<cr>",
            { buffer = true, desc = "Obsidian toggle checkbox" }
          )
        end,
      },
    },
  },

  {
    "nextmn/vim-yaml-jinja",
    lazy = false,
  },
  {
    "Julian/lean.nvim",
    event = { "BufReadPre *.lean", "BufNewFile *.lean" },

    dependencies = {
      "nvim-lua/plenary.nvim",

      -- optional dependencies:

      -- a completion engine
      --    hrsh7th/nvim-cmp or Saghen/blink.cmp are popular choices

      "nvim-telescope/telescope.nvim", -- for 2 Lean-specific pickers
      "andymass/vim-matchup", -- for enhanced % motion behavior
      -- 'andrewradev/switch.vim',        -- for switch support
      "tomtom/tcomment_vim", -- for commenting
    },

    opts = {
      mappings = true,
    },
  },
  {
    -- Unison
    "unisonweb/unison",
    branch = "trunk",
    config = function(plugin)
      vim.opt.rtp:append(plugin.dir .. "/editor-support/vim")
      require("lazy.core.loader").packadd(plugin.dir .. "/editor-support/vim")
    end,
    init = function(plugin)
      require("lazy.core.loader").ftdetect(plugin.dir .. "/editor-support/vim")
    end,
  },
  -- { "Apeiros-46B/uiua.vim" },
  { "sputnick1124/uiua.vim" },
}
