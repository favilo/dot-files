-- LSP, completion engine, and LSP-adjacent UI.
return {
  {
    'williamboman/mason.nvim',
    lazy = false,
    opts = {
      PATH = "prepend",
      ui = {
        border = "rounded",
      },
    },
  },

  -- Completion: blink.cmp (single engine)
  {
    "saghen/blink.cmp",
    version = "*", -- release tags; prebuilt fuzzy binary
    event = "InsertEnter",
    dependencies = {
      "saghen/blink.lib",
      "rafamadriz/friendly-snippets",
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
      },
      "saghen/blink.compat", -- bridge for legacy cmp sources (digraphs)
      "dmitmel/cmp-digraphs",
    },
    opts = {
      snippets = { preset = "luasnip" },
      keymap = {
        preset = "default", -- <C-y> accept, <C-n>/<C-p> select, Tab/S-Tab snippet jump
        ["<Tab>"] = {
          function(cmp)
            -- When the blink menu is open, it owns <Tab> (accept the selection).
            if cmp.is_visible() then
              if cmp.snippet_active() then return cmp.accept() end
              return cmp.select_and_accept()
            end
            -- Otherwise accept a visible Copilot ghost-text suggestion.
            local ok, sug = pcall(require, "copilot.suggestion")
            if ok and sug.is_visible() then
              sug.accept()
              return true
            end
            return false -- fall through to snippet jump / real <Tab>
          end,
          "snippet_forward",
          "fallback",
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "digraphs" },
        providers = {
          digraphs = {
            name = "digraphs",
            module = "blink.compat.source",
            score_offset = -3, -- rank below native sources
            opts = { cache_digraphs_on_start = true },
          },
        },
      },
      completion = {
        -- Only open the menu on LSP trigger chars (., :, etc.) or manually
        -- via <C-space>; while typing words, Copilot ghost-text shows instead.
        trigger = { show_on_keyword = false },
        menu = { border = "rounded" },
        documentation = { auto_show = true, window = { border = "rounded" } },
      },
    },
  },
  {
    "saghen/blink.compat",
    version = "2.*", -- pairs with blink.cmp v1.x
    lazy = true,
    opts = {},
  },
  {
    'neovim/nvim-lspconfig',
    lazy = false,
    cmd = { 'LspInfo', 'LspInstall', 'LspStart', 'LspRestart', 'LspStop' },
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'williamboman/mason.nvim',
      {
        'williamboman/mason-lspconfig.nvim',
        lazy = false,
        -- build = ':PylspInstall python-lsp-black pyls-isort pylsp-rope pylsp-mypy pylint',
      },
      'folke/neodev.nvim',
      -- 'mrcjkb/rustaceanvim',
      'b0o/schemastore.nvim',
      "lukas-reineke/lsp-format.nvim",
    },
    -- Diagnostics are configured authoritatively in lua/plugins/lsp/config.lua
    -- (via vim.diagnostic.config). nvim-lspconfig never consumed an `opts`
    -- table here, so it was dead config.
    config = function()
      require('plugins.lsp.config')
      require('plugins.lsp.setup')
    end,
  },
  {
    "vxpm/ferris.nvim",
    opts = {
      create_commands = true,
    },
  },

  {
    "j-hui/fidget.nvim",
    lazy = false,
    opts = {
      progress = {
        poll_rate = 0,                -- How and when to poll for progress messages
        suppress_on_insert = false,   -- Suppress new messages while in insert mode
        ignore_done_already = false,  -- Ignore new tasks that are already complete
        ignore_empty_message = false, -- Ignore new tasks that don't contain a message
        clear_on_detach =             -- Clear notification group when LSP server detaches
            function(client_id)
              local client = vim.lsp.get_client_by_id(client_id)
              return client and client.name or nil
            end,
        notification_group = -- How to get a progress message's notification group key
            function(msg) return msg.lsp_client.name end,
        ignore = {},         -- List of LSP servers to ignore

        -- Options related to how LSP progress messages are displayed as notifications
        -- display = {
        --   render_limit = 16, -- How many LSP messages to show at once
        --   done_ttl = 3, -- How long a message should persist after completion
        --   done_icon = "✔", -- Icon shown when all LSP progress tasks are complete
        --   done_style = "Constant", -- Highlight group for completed LSP tasks
        --   progress_ttl = math.huge, -- How long a message should persist when in progress
        --   progress_icon = -- Icon shown when LSP progress tasks are in progress
        --   { "dots" },
        --   progress_style = -- Highlight group for in-progress LSP tasks
        --   "WarningMsg",
        --   group_style = "Title", -- Highlight group for group name (LSP server name)
        --   icon_style = "Question", -- Highlight group for group icons
        --   priority = 30, -- Ordering priority for LSP notification group
        --   skip_history = true, -- Whether progress notifications should be omitted from history
        --   format_message = -- How to format a progress message
        --       require("fidget.progress.display").default_format_message,
        --   format_annote = -- How to format a progress annotation
        --       function(msg) return msg.title end,
        --   format_group_name = -- How to format a progress notification group's name
        --       function(group) return tostring(group) end,
        --   overrides = { -- Override options from the default notification config
        --     rust_analyzer = { name = "rust-analyzer" },
        --   },
        -- },

        -- Options related to Neovim's built-in LSP client
        lsp = {
          progress_ringbuf_size = 0, -- Configure the nvim's LSP progress ring buffer size
          log_handler = false,       -- Log `$/progress` handler invocations (for debugging)
        },
      },

      -- Options related to notification subsystem
      -- notification = {
      --   poll_rate = 10,           -- How frequently to update and render notifications
      --   filter = vim.log.levels.INFO, -- Minimum notifications level
      --   history_size = 128,       -- Number of removed messages to retain in history
      --   override_vim_notify = false, -- Automatically override vim.notify() with Fidget
      --   configs =                 -- How to configure notification groups when instantiated
      --   { default = require("fidget.notification").default_config },
      --   redirect =                -- Conditionally redirect notifications to another backend
      --       function(msg, level, opts)
      --         if opts and opts.on_open then
      --           return require("fidget.integration.nvim-notify").delegate(msg, level, opts)
      --         end
      --       end,
      --
      --   -- Options related to how notifications are rendered as text
      --   view = {
      --     stack_upwards = true, -- Display notification items from bottom to top
      --     icon_separator = " ", -- Separator between group name and icon
      --     group_separator = "---", -- Separator between notification groups
      --     group_separator_hl = -- Highlight group used for group separator
      --     "Comment",
      --     line_margin = 1,     -- Spaces to pad both sides of each non-empty line
      --     render_message =     -- How to render notification messages
      --         function(msg, cnt)
      --           return cnt == 1 and msg or string.format("(%dx) %s", cnt, msg)
      --         end,
      --   },
      --
      --   -- Options related to the notification window and buffer
      --   window = {
      --     normal_hl = "Comment", -- Base highlight group in the notification window
      --     winblend = 100,    -- Background color opacity in the notification window
      --     border = "none",   -- Border around the notification window
      --     zindex = 45,       -- Stacking priority of the notification window
      --     max_width = 0,     -- Maximum width of the notification window
      --     max_height = 0,    -- Maximum height of the notification window
      --     x_padding = 1,     -- Padding from right edge of window boundary
      --     y_padding = 0,     -- Padding from bottom edge of window boundary
      --     align = "bottom",  -- How to align the notification window
      --     relative = "editor", -- What the notification window position is relative to
      --     tabstop = 8,       -- Width of each tab character in the notification window
      --   },
      -- },

      -- Options related to integrating with other plugins
      integration = {
        ["nvim-tree"] = {
          enable = true, -- Integrate with nvim-tree/nvim-tree.lua (if installed)
        },
        ["xcodebuild-nvim"] = {
          enable = true, -- Integrate with wojciech-kulik/xcodebuild.nvim (if installed)
        },
      },

      -- Options related to logging
      logger = {
        level = vim.log.levels.WARN, -- Minimum logging level
        max_size = 10000,            -- Maximum log file size, in KB
        float_precision = 0.01,      -- Limit the number of decimals displayed for floats
        path =                       -- Where Fidget writes its logs to
            string.format("%s/fidget.nvim.log", vim.fn.stdpath("cache")),
      },
    },
  },

  { 'ray-x/lsp_signature.nvim' },
  {
    'aznhe21/actions-preview.nvim',
  },
  {
    'weilbith/nvim-code-action-menu',
    cmd = 'CodeActionMenu',
  },
}
