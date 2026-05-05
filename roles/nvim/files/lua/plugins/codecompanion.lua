require("codecompanion").setup({
  -- Your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
  adapters = {
    http = {
      google_op = function()
        return require("codecompanion.adapters").extend("gemini", {
          env = {
            api_key = "cmd:op --account oberlies read op://Private/GeminiAPI/credential --no-newline",
          },
        })
      end,
    },
  },
  interactions = {
    chat = {
      adapter = "google_op",
    },
    inline = {
      adapter = "google_op",
    },
    cmd = {
      adapter = "google_op",
    }
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
})
