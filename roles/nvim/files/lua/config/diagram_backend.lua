local M = {}

function M.get()
	if vim.env.WEZTERM_PANE ~= nil then
		return "sixel"
	end

	local is_kitty = vim.env.KITTY_PID ~= nil or vim.env.TERM == "xterm-kitty"
	if vim.env.ZELLIJ == nil and is_kitty then
		return "kitty"
	end
end

return M
