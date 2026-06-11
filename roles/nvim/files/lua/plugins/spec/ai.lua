-- AI assistants: Copilot and CodeCompanion.
local home_dir = os.getenv('HOME')
vim.g.copilot_node_command = home_dir .. "/.local/bin/nodejs"

return {
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
      vim.keymap.set("n", "<leader>cs", toggle_auto_trigger, { desc = "Copilot suggestion toggle" })
      vim.keymap.set("i", "<C-e>", toggle_auto_trigger, { desc = "Copilot suggestion toggle (insert mode)" })
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    config = function()
      require("plugins.codecompanion")
    end,
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
