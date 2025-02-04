vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46_cache/"
vim.g.have_nerd_font = true

require("utils.globals")
require("utils.functions")

require("config.options")
require("config.lazy")
require("config.colors")

require("config.keymaps")

require("lsp.config")
require("lsp.setup")
