local builtin = require('telescope.builtin')
require('telescope').load_extension('projects')
require('telescope').load_extension('fzf')
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

vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('v', '<leader>pf', function() builtin.find_files({ default_text = vim.getVisualSelection() }) end, {})
vim.keymap.set('n', '<leader>pp', function() builtin.find_files({ hidden = true }) end, {})
vim.keymap.set('n', '<leader>pb', builtin.buffers, {})
vim.keymap.set('n', '<leader>po', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>pe', require 'telescope'.extensions.projects.projects, {})

vim.keymap.set('n', '<C-p>', builtin.git_files, {})


vim.keymap.set('n', '<leader>sp', builtin.live_grep, {})
vim.keymap.set('v', '<leader>sp', function() builtin.live_grep({ default_text = vim.getVisualSelection() }) end, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fc', builtin.command_history, {})
vim.keymap.set('n', '<leader>ff', builtin.treesitter, {})
