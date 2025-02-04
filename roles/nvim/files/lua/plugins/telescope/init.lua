local telescope = require('telescope')
-- local actions = require('telescope.actions')
-- local previewers = require('telescope.previewers')
local builtin = require('telescope.builtin')
local icons = require('utils.icons')

telescope.load_extension('projects')
telescope.load_extension('fzf')
telescope.load_extension('live_grep_args')
telescope.load_extension('repo')
-- telescope.load_extension("git_worktree")
-- telescope.load_extension('dap')
--
local git_icons = {
  added = icons.gitAdd,
  changed = icons.gitChange,
  copied = ">",
  deleted = icons.gitRemove,
  renamed = "➡",
  unmerged = "‡",
  untracked = "?",
}

-- telescope.setup({})
telescope.setup {
  defaults = {
    border            = true,
    hl_result_eol     = true,
    multi_icon        = '',
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    layout_config     = {
      horizontal = {
        preview_cutoff = 120,
      },
      prompt_position = "top",
    },
    file_sorter       = require('telescope.sorters').get_fzy_sorter,
    -- prompt_prefix     = '  ',
    color_devicons    = true,
    git_icons         = git_icons,
    sorting_strategy  = "ascending",
    file_previewer    = require('telescope.previewers').vim_buffer_cat.new,
    grep_previewer    = require('telescope.previewers').vim_buffer_vimgrep.new,
    qflist_previewer  = require('telescope.previewers').vim_buffer_qflist.new,
    -- mappings          = {
    --   i = {
    --     ["<C-x>"] = false,
    --     ["<C-j>"] = actions.move_selection_next,
    --     ["<C-k>"] = actions.move_selection_previous,
    --     ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
    --     ["<C-s>"] = actions.cycle_previewers_next,
    --     ["<C-a>"] = actions.cycle_previewers_prev,
    --     -- ["<C-h>"] = "which_key",
    --     ["<ESC>"] = actions.close,
    --   },
    --   n = {
    --     ["<C-s>"] = actions.cycle_previewers_next,
    --     ["<C-a>"] = actions.cycle_previewers_prev,
    --   }
    -- }
  },
  extensions = {
  }
}


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
