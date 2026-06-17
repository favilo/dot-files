-- Inline rendering of mermaid (and other) diagrams directly in the buffer via
-- the kitty graphics protocol. Requires a graphics-capable terminal (kitty),
-- the `mmdc` CLI (@mermaid-js/mermaid-cli) to render mermaid, and ImageMagick
-- (`magick`) to process the images -- both installed by the packages role.
return {
  {
    "3rd/image.nvim",
    event = "VeryLazy",
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
            -- blocks unprivileged user namespaces, so Chromium can't build its
            -- sandbox. Launch it with --no-sandbox (safe for trusted local
            -- diagram source) via this puppeteer config rather than disabling
            -- the restriction system-wide.
            cli_args = { "--puppeteerConfigFile", vim.fn.stdpath("config") .. "/puppeteer-config.json" },
          },
        },
      }
    end,
  },
}
