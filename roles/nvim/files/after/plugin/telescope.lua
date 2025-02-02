local telescope = require('telescope')
local builtin = require('telescope.builtin')
telescope.setup({})
require('telescope').load_extension('projects')
require('telescope').load_extension('fzf')
require('telescope').load_extension('live_grep_args')
-- require('telescope').load_extension('dap')

function vim.getVisualSelection()
    vim.cmd('noau normal! "vy"')
    local text = vim.fn.getreg('v')
    vim.fn.setreg('v', {})

    text = string.gsub(text, "\n", "")
    if #text > 0 then
        return text
    else
        return ''
    end
end

vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set('v', '<leader>pf', function() builtin.find_files({ default_text = vim.getVisualSelection() }) end,
    { desc = "Telescope find files" })
vim.keymap.set('n', '<leader>pp', function() builtin.find_files({ hidden = true, no_ignore = true }) end,
    { desc = "Telescope find hidden files" })
vim.keymap.set('n', '<leader>pb', builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set('n', '<leader>po', builtin.oldfiles, { desc = "Telescope oldfiles" })
vim.keymap.set('n', '<leader>pe', require 'telescope'.extensions.projects.projects, { desc = "Telescope projects" })
vim.keymap.set('n', '<leader>p.', function() builtin.find_files({ cwd = vim.fn.expand('%:p:h') }) end,
    { desc = "Telescope find sibling files" })

vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = "Telescope git files" })


vim.keymap.set('n', '<leader>sp', builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set('v', '<leader>sp', function() builtin.live_grep({ default_text = vim.getVisualSelection() }) end,
    { desc = "Telescope live grep (starting w/ selected text)" })


local hidden_args = { '--no-ignore', '--no-ignore-vcs', }
vim.keymap.set('n', '<leader>so',
    function() builtin.live_grep({ additional_args = hidden_args }) end, { desc = "Telescope live grep with hidden" })
vim.keymap.set('v', '<leader>so',
    function() builtin.live_grep({ default_text = vim.getVisualSelection(), additional_args = hidden_args }) end,
    { desc = "Telescope live grep with hidden (starting w/ selected text)" })
vim.keymap.set('n', '<leader>sa',
    function() telescope.extensions.live_grep_args.live_grep_args({ additional_args = hidden_args }) end,
    { desc = "Telescope live grep with hidden" })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Telescope live grep through nvim help tags" })
vim.keymap.set('n', '<leader>fc', builtin.command_history, { desc = "Telescope live grep through command history" })
vim.keymap.set('n', '<leader>ff', builtin.treesitter, { desc = "Telescope grep through variables in scope" })
