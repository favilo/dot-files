local diagram_backend = require("config.diagram_backend")

-- WezTerm supports Sixel, which also survives Zellij. Kitty graphics do not,
-- so use that backend only in direct Kitty sessions.
return {
  {
    "3rd/image.nvim",
    event = "VeryLazy",
    cond = function()
      return diagram_backend.get() ~= nil
    end,
    opts = function()
      return {
        backend = diagram_backend.get(),
        -- Use the ImageMagick CLI rather than the `magick` luarock, so there is
        -- no luarocks build step to maintain.
        processor = "magick_cli",
        -- diagram.nvim drives the rendering; don't also auto-render markdown images.
        integrations = {},
        max_width_window_percentage = 80,
        max_height_window_percentage = 80,
      }
    end,
  },
  {
    "3rd/diagram.nvim",
    dependencies = { "3rd/image.nvim" },
    ft = { "markdown" },
    cond = function()
      return diagram_backend.get() ~= nil
    end,
    -- opts is a function so the integration module is required only after the
    -- plugin is on the runtimepath.
    opts = function()
      return {
        integrations = {
          require("diagram.integrations.markdown"),
        },
        renderer_options = {
          mermaid = {
            theme = "dark",
            -- mmdc drives Chromium via puppeteer; on Ubuntu 23.10+ AppArmor
            cli_args = {},
          },
        },
      }
    end,
  },
}
