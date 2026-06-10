-- AI assistants: Copilot and CodeCompanion.
local home_dir = os.getenv('HOME')
vim.g.copilot_node_command = home_dir .. "/.local/bin/nodejs"

return {
  {
    'github/copilot.vim',
    cmd = { "CopilotVim", },
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        panel = {
          enabled = true,
          auto_refresh = true,
        },
        suggestion = {
          -- Inline ghost-text is the Copilot UX; the blink menu is reserved for
          -- LSP/path/snippets and only opens on trigger chars or <C-space>.
          enabled = true,
          auto_trigger = true,
          hide_during_completion = true,
          keymap = {
            -- <Tab> is owned by blink.cmp's keymap (accepts visible Copilot first).
            accept = false,
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
        },
        server = {
          type = "nodejs",
          custom_server_filepath = nil,
        },
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
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    config = function()
      require("plugins.codecompanion")
    end,
    -- opts = {
    --   strategies = {
    --     -- Change the default chat adapter
    --     chat = {
    --       adapter = "google",
    --       model = "gemini-3.1-pro",
    --     },
    --     inline = {
    --       adapter = "google",
    --       -- model = "gemini-2.5-pro",
    --     },
    --     roles = {
    --       user = "favilo",
    --     },
    --     keymaps = {
    --       send = {
    --         modes = {
    --           i = { "<C-CR>", "<C-s>" },
    --         },
    --       },
    --       completion = {
    --         modes = {
    --           i = "<C-x>",
    --         },
    --       },
    --     },
    --   },
    --   adapters = {
    --     -- copilot = function()
    --     --   return require("codecompanion.adapters").extend("copilot", {
    --     --     schema = {
    --     --       model = {
    --     --         default = "gemini-2.5-flash-preview",
    --     --       },
    --     --     },
    --     --     env = {
    --     --       api_key = "cmd:op read op://Private/GeminiAPI/credential --no-newline",
    --     --     },
    --     --   })
    --     -- end,
    --   },
    --   extensions = {
    --     history = {
    --       enabled = true,
    --       opts = {
    --         keymap = "gh",
    --         save_chat_keymap = "sc",
    --         auto_save = false,
    --         auto_generate_title = true,
    --         continue_last_chat = false,
    --         delete_on_clearing_chat = false,
    --         picker = "snacks",
    --         enable_logging = false,
    --         dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
    --       },
    --     },
    --     mcphub = {
    --       callback = "mcphub.extensions.codecompanion",
    --       opts = {
    --         make_vars = true,
    --         make_slash_commands = true,
    --         show_result_in_chat = true,
    --       },
    --     },
    --   },
    --   opts = {
    --     -- Set debug logging
    --     log_level = "DEBUG",
    --   },
    --   keys = {
    --     {
    --       "<C-a>",
    --       "<cmd>CodeCompanionActions<CR>",
    --       desc = "Open the action palette",
    --       mode = { "n", "v" },
    --     },
    --     {
    --       "<Leader>a",
    --       "<cmd>CodeCompanionChat Toggle<CR>",
    --       desc = "Toggle a chat buffer",
    --       mode = { "n", "v" },
    --     },
    --     {
    --       "<LocalLeader>a",
    --       "<cmd>CodeCompanionChat Add<CR>",
    --       desc = "Add code to a chat buffer",
    --       mode = { "v" },
    --     },
    --   },
    -- },
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
}
