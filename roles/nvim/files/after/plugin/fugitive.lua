vim.keymap.set("n", "<leader>gg", vim.cmd.Git)

local favilo_Fugitive = vim.api.nvim_create_augroup("favilo_Fugitive", {})

local autocmd = vim.api.nvim_create_autocmd
autocmd("BufWinEnter", {
	group = favilo_Fugitive,
	pattern = "*",
	callback = function()
		if vim.bo.ft ~= "fugitive" then
			return
		end

		local bufnr = vim.api.nvim_get_current_buf()
		local opts = {buffer = bufnr, remap = false}
		vim.keymap.set("n", "<leader>pp", function()
			vim.cmd.Git('push')
		end, opts)

		vim.keymap.set("n", "<leader>F", function()
			vim.cmd.Git({'pull', '--rebase'})
		end, opts)

		vim.keymap.set("n", "<leader>pu", ":Git push -u origin ", opts)
	end,
})
