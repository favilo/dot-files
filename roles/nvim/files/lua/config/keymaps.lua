vim.keymap.set("n", "<leader>pv", vim.cmd.Oil, { desc = "Open Oil file explorer" })

vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Window: focus down" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Window: focus left" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Window: focus right" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Window: focus up" })

vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "Window: focus down (from terminal)" })
vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "Window: focus left (from terminal)" })
vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l", { desc = "Window: focus right (from terminal)" })
vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "Window: focus up (from terminal)" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

vim.keymap.set("v", ">", ">gv", { desc = "Indent right and keep selection" })
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and keep selection" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join line below, keep cursor" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half-page down, centered" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half-page up, centered" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search match, centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Prev search match, centered" })

vim.keymap.set("v", "<leader>P", [["_dP]], { desc = "Paste over selection (keep register)" })

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })

vim.keymap.set({ "n", "v" }, "<leader>x", [["_d]], { desc = "Delete to void register" })

vim.keymap.set("n", "Q", "<nop>", { desc = "Disable Ex mode" })
-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

vim.keymap.set("n", "<leader>goo", vim.cmd.GBrowse, { desc = "Git: open file in browser (GBrowse)" })
vim.keymap.set("v", "<leader>go", vim.cmd.GBrowse, { desc = "Git: open selection in browser (GBrowse)" })

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Terminal: exit to normal mode" })

vim.keymap.set("n", "<leader>rr", "yyp!!sh<CR>", { desc = "Run current line through sh" })
vim.keymap.set("v", "<leader>rr", "!sh<CR>", { desc = "Run selection through sh" })

vim.keymap.set("c", "w!!", "execute 'silent! write !sudo tee % >/dev/null' <bar> edit!",
  { desc = "Write current file with sudo" })
vim.keymap.set({ "n", "v" }, "<leader>at", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "CodeCompanion chat toggle" })
vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionActions<CR>", { desc = "CodeCompanion action palette" })
vim.keymap.set("v", "<localleader>a", "<cmd>CodeCompanionChat Add<CR>", { desc = "CodeCompanion add selection to chat" })
vim.keymap.set("n", "<leader>cP", vim.show_pos, { desc = "Inspect: position highlights" })
