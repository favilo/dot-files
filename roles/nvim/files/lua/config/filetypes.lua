-- Central home for custom filetype detection.
--
-- Plugin and LSP setup files are the wrong place for filetype rules — they only
-- run when that plugin loads. Registering here (required from init.lua) keeps
-- detection independent of plugin load order.
--
-- NOTE: microcad's extension map lives in lua/plugins/treesitter.lua, where it
-- sits alongside its parser install_info and vim.treesitter.language.register.
vim.filetype.add({
  extension = {
    -- lux test scripts
    lux = "lux",
    luxcfg = "lux",
    luxinc = "lux",
    -- Allium specs
    allium = "allium",
    -- Beancount ledgers
    bean = "beancount",
  },
})
