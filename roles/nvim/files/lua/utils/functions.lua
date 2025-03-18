-- Exported functions
local M = {}

local present, win = pcall(require, "lspconfig.ui.windows")
if not present then
  return
end

local _default_opts = win.default_opts
win.default_opts = function(options)
  local opts = _default_opts(options)
  opts.border = "rounded"
  return opts
end

local is_windows = function()
    if (string.sub(vim.loop.os_uname().sysname, 1, 3) == "Win") then
        return true
    end
    return false
end

M.is_windows = is_windows

return M
