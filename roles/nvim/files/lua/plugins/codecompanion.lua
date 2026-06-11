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
  -- NOTE: keymaps live in lua/config/keymaps.lua (<leader>at toggle, <leader>aa
  -- actions, <localleader>a add). setup() has no top-level `keys` option — that
  -- lazy-spec format was inert here, so it has been removed.
})
