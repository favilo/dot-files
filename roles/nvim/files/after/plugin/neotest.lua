vim.g.rustaceanvim.tools.test_executor = 'background'

require("neotest").setup({
    adapters = {
        require("neotest-python")({
            dap = { justMyCode = false },
            runner = "pytest",
            python = ".venv/bin/python",
            pytest_discover_instances = true,
        }),
        require("rustaceanvim.neotest"),
        require("neotest-plenary"),
        require("neotest-vim-test")({
            ignore_file_types = { "python", "vim", "lua" },
        }),
    },
})

vim.keymap.set({ 'v', 'n' }, '<leader>rt', function() require('neotest').run.run() end, { desc = "Run nearest test" })
vim.keymap.set({ 'v', 'n' }, '<leader>dt', function() require('neotest').run.run({ strategy = 'dap' }) end,
    { desc = "Debug nearest test" })
vim.keymap.set({ 'v', 'n' }, '<leader>df',
    function() require('neotest').run.run({ vim.fn.expand("%"), strategy = 'dap' }) end,
    { desc = "Debug current file" })
vim.keymap.set({ 'n', 'v' }, '<leader>rf', function() require('neotest').run.run(vim.fn.expand("%")) end,
    { desc = "Run current file" })
vim.keymap.set({ 'n', 'v' }, '<leader>dL', function() require('neotest').run.run_last({ strategy = 'dap' }) end,
    { desc = "Debug last test" })
vim.keymap.set({ 'n', 'v' }, '<leader>rL', function() require('neotest').run.run_last() end,
    { desc = "Run last test" })
vim.keymap.set({ 'n', 'v' }, '<leader>dO', function() require('neotest').output.open({ enter = true }) end,
    { desc = "Show output" })
vim.keymap.set({ 'n', 'v' }, '<leader>ds', function() require('neotest').run.stop() end,
    { desc = "Stop" })
vim.keymap.set({ 'n', 'v' }, '<leader>dS', function() require('neotest').summary.toggle() end,
    { desc = "Show summary" })
