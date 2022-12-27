local builtin = require('telescope.builtin')
require('telescope').load_extension('projects')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<leader>pe', require 'telescope'.extensions.projects.projects, {})

vim.keymap.set('n', '<C-p>', builtin.git_files, {})

vim.keymap.set('n', '<leader>sp', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
