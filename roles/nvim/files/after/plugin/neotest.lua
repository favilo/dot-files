require("neotest").setup({
    adapters = {
        require("neotest-python")({
            dap = { justMyCode = false },
        }),
        require("neotest-plenary"),
        require("neotest-vim-test")({
            ignore_file_types = { "python", "vim", "lua" },
        }),
    },
})

vim.keymap.set('n', '<leader>td', function() require('neotest').run.run({strategy = 'dap'}) end, {})
vim.keymap.set('n', '<leader>tf', function() require('neotest').run.run({vim.fn.expand("%"), strategy = 'dap'}) end, {})
vim.keymap.set('n', '<leader>dt', function() require('neotest').run.run({strategy = 'dap'}) end, {})
