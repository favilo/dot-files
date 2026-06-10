vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46_cache/"
vim.g.have_nerd_font = true

require("utils.globals")

require("config.options")
require("config.filetypes")
require("config.lazy")
require("config.colors")

require("config.keymaps")
