-- Inline diagram rendering relies on the Kitty graphics protocol. Zellij does
-- not forward that protocol, and Ueberzug++ overlays cannot track its panes or
-- tabs, so Markdown uses its external-viewer fallback there instead.
return {
  {
    "3rd/image.nvim",
    event = "VeryLazy",
    cond = function()
      return vim.env.ZELLIJ == nil
    end,
    opts = {
      backend = "kitty",
      -- Use the ImageMagick CLI rather than the `magick` luarock, so there is
      -- no luarocks build step to maintain.
      processor = "magick_cli",
      -- diagram.nvim drives the rendering; don't also auto-render markdown images.
      integrations = {},
      max_width_window_percentage = 80,
      max_height_window_percentage = 80,
    },
  },
  {
    "3rd/diagram.nvim",
    dependencies = { "3rd/image.nvim" },
    ft = { "markdown" },
    cond = function()
      return vim.env.ZELLIJ == nil
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
