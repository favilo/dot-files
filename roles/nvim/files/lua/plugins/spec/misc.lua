-- Standalone utilities and libraries that don't fit a larger group.
return {
  { "mrjones2014/op.nvim", build = "make install" },
  { "nvim-lua/plenary.nvim" },
  { "lambdalisue/suda.vim" },
  {
    "wakatime/vim-wakatime",
    lazy = false,
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
  { "sk1418/HowMuch" },
  { "diepm/vim-rest-console" },

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
      vim.keymap.set("n", "<leader>o", function()
        require("outline").toggle({ placement = "topleft", focus_outline = false })
      end, { desc = "Toggle Outline" })
      vim.keymap.set("n", "<leader>O", function()
        require("outline").focus_toggle()
      end, { desc = "Focus Outline" })

      require("outline").setup({
        -- Your setup opts here (leave empty to use defaults)
      })
    end,
  },

  {
    "Vigemus/iron.nvim",
    config = function()
      require("plugins.iron")
    end,
  },
  {
    "fresh2dev/zellij.vim",
    lazy = false,
    init = function()
      -- vim.g.zelli_navigator_move_focus_or_tab = 1
      -- vim.g.zellij_navigator_no_default_mappings = 1
    end,
  },
  {
    "m00qek/baleia.nvim",
    version = "*",
    config = function()
      vim.g.baleia = require("baleia").setup({})

      -- Command to colorize the current buffer
      vim.api.nvim_create_user_command("BaleiaColorize", function()
        vim.g.baleia.once(vim.api.nvim_get_current_buf())
      end, { bang = true })

      -- Command to show logs
      vim.api.nvim_create_user_command("BaleiaLogs", vim.cmd.messages, { bang = true })
      vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
        pattern = "*.log",
        callback = function()
          vim.g.baleia.automatically(vim.api.nvim_get_current_buf())
        end,
      })
    end,
  },
  {
    "0xferrous/ansi.nvim",
    config = function()
      require("ansi").setup({
        auto_enable = false, -- Auto-enable for configured filetypes
        auto_enable_stdin = true, -- Auto-enable for piped stdin content
        filetypes = { "log", "ansi" },
      })
    end,
  },
}
