require('telescope').load_extension('git_worktree')
local Hooks = require("git-worktree.hooks")
local config = require("git-worktree.config")

local Path = require("plenary.path")

-- @type git-worktree.hooks.cb.switch
local update_all_buffers_on_switch = function(_, prev_path)
  local update_cmd = function(win)
    vim.api.nvim_win_call(win, function()
      vim.cmd(config.update_on_change_command)
    end)
  end


  local cwd = vim.loop.cwd()
  vim.tbl_map(function(win)
    if prev_path == nil then
      update_cmd(win)
      return
    end
    local buf = vim.api.nvim_win_get_buf(win)
    local current_buf_name = vim.api.nvim_buf_get_name(buf)

    if not current_buf_name or current_buf_name == "" then
      update_cmd(win)
      return
    end

    local name = Path:new(current_buf_name):absolute()
    local start1, _ = string.find(name, cwd .. Path.path.sep, 1, true)
    if start1 ~= nil then
      return
    end

    local start, fin = string.find(name, prev_path, 1, true)
    if start == nil then
      vim.notify(name .. " does not contain the previous path: " .. prev_path)
      -- update_cmd(win)
      return
    end

    local local_name = name:sub(fin + 2)

    local final_path = Path:new({ cwd, local_name }):absolute()

    if not Path:new(final_path):exists() then
      vim.notfiy("Path does not exist: " .. final_path)
      update_cmd(win)
      return
    end

    local bufnr = vim.fn.bufnr(final_path, true)
    vim.api.nvim_set_option_value("buflisted", true, { buf = bufnr })
    vim.api.nvim_win_set_buf(win, bufnr)
  end, vim.api.nvim_list_wins())
end


Hooks.register(Hooks.type.SWITCH, function(path, prev_path)
  vim.notify("Moved from " .. prev_path .. " to " .. path)
  update_all_buffers_on_switch(path, prev_path)
end)

Hooks.register(Hooks.type.DELETE, function()
  vim.cmd(config.update_on_change_command)
end)

vim.keymap.set("n", "<leader>gw", function()
  require("telescope").extensions.git_worktree.git_worktree()
end, { desc = "worktree_switch" })
vim.keymap.set("n", "<leader>gW", function()
  require("telescope").extensions.git_worktree.create_git_worktree()
end, { desc = "worktree_switch" })
