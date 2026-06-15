-- tests/minimal_init.lua
-- Boots the REAL config so tests exercise the same load path as a live session.
-- Run via: nvim --headless -u tests/minimal_init.lua -c "PlenaryBustedDirectory ..."
--
-- Note: we deliberately do NOT pass --noplugin. lazy.nvim loads its start
-- (lazy=false) plugins during setup; without --noplugin those land on the
-- runtimepath so nvim-treesitter, treesitter-modules and the nightfly
-- colorscheme are all available, exactly as in a live session.

-- This file lives at <config>/tests/minimal_init.lua; config root is two dirs up.
local this = vim.fn.resolve(debug.getinfo(1, "S").source:sub(2))
local config_root = vim.fn.fnamemodify(this, ":p:h:h")

local data = vim.fn.stdpath("data")
local lazypath = data .. "/lazy/lazy.nvim"
local plenarypath = data .. "/lazy/plenary.nvim"

-- plenary + lazy must be reachable before we touch either.
vim.opt.rtp:prepend(plenarypath)
vim.opt.rtp:prepend(lazypath)
vim.opt.rtp:prepend(config_root)

-- Make plenary's PlenaryBusted* commands available immediately.
vim.cmd("runtime plugin/plenary.vim")

-- Source the real config exactly as a session would (errors here fail loudly).
dofile(config_root .. "/init.lua")

-- Ensure plenary itself is loaded for the busted runner (it is a lazy dependency).
pcall(function()
  require("lazy").load({ plugins = { "plenary.nvim" } })
end)
