require("neodev").setup({
    library = { plugins = { "nvim-dap-ui" }, types = true },
})
local dap = require('dap')
local dapui = require('dapui')
dap.adapters.python = function(cb, config)
    if config.request == 'attach' then
        ---@diagnostic disable-next-line: undefined-field
        local port = (config.connect or config).port
        ---@diagnostic disable-next-line: undefined-field
        local host = (config.connect or config).host or '127.0.0.1'
        cb({
            type = 'server',
            port = assert(port, '`connect.port` is required for a python `attach` configuration'),
            host = host,
            options = {
                source_filetype = 'python',
            },
        })
    else
        cb({
            type = 'executable',
            command = '~/.local/share/nvim/mason/bin/debugpy',
            args = {},
            options = {
                source_filetype = 'python',
            },
        })
    end
end

dap.configurations.python = {
    {
        -- The first three options are required by nvim-dap
        type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
        request = 'launch',
        name = "Launch file",

        -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

        program = "${file}", -- This configuration will launch the current file if used.
        pythonPath = function()
            -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
            -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
            -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
                return cwd .. '/venv/bin/python'
            elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
                return cwd .. '/.venv/bin/python'
            else
                return '/usr/bin/python'
            end
        end,
    },
}

dapui.setup()
dap.listeners.after.event_initialized['dapui_config'] = function()
    dapui.open()
end
dap.listeners.before.event_terminated['dapui_config'] = function()
    dapui.close()
end
dap.listeners.before.event_exited['dapui_config'] = function()
    dapui.close()
end

require('dap-python').setup('~/.local/share/nvim/mason/packages/debugpy/venv/bin/python')
-- require('core.utils').load_mappings("dap_python")

-- dap.adapters.lldb = {
--     type = 'executable',
--     command = '/usr/bin/lldb-vscode',
--     name = 'lldb',
-- }

-- dap.configurations.cpp = {
--     {
--         name = 'Launch',
--         type = 'lldb',
--         request = 'launch',
--         program = function()
--             return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--         end,
--         cwd = '${workspaceFolder}',
--         stopOnEntry = false,
--         args = {},
--         runInTerminal = false,
--     }
-- }

-- dap.configurations.c = dap.configurations.cpp
-- dap.configurations.rust = dap.configurations.cpp

-- local rt = require("rust-tools")

-- rt.setup({
--     server = {
--         on_attach = function(_, bufnr)
--             vim.keymap.set("n", "<Leader>cc", rt.hover_actions.hover_actions, { buffer = bufnr })
--             -- vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
--         end,
--     }
-- })

local continue = function()
    if vim.fn.filereadable(".vscode/launch.json") then
        require('dap.ext.vscode').load_launchjs()
    end
    require('dap').continue()
end

-- DAP mappings
vim.keymap.set('n', '<leader>dc', continue)
vim.keymap.set('n', '<leader>do', function() require('dap').step_over() end)
vim.keymap.set('n', '<leader>di', function() require('dap').step_into() end)
vim.keymap.set('n', '<leader>du', function() require('dap').step_out() end)
vim.keymap.set('n', '<leader>db', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<leader>dB', function() require('dap').set_breakpoint() end)
vim.keymap.set('n', '<leader>dm',
    function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<leader>dr', function() require('dap').repl.open() end)
vim.keymap.set('n', '<leader>dl', function() require('dap').run_last() end)
vim.keymap.set({ 'n', 'v' }, '<leader>dh', function()
    require('dap.ui.widgets').hover()
end)
vim.keymap.set({ 'n', 'v' }, '<leader>dp', function()
    require('dap.ui.widgets').preview()
end)
vim.keymap.set('n', '<leader>df', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.frames)
end)
vim.keymap.set('n', '<leader>ds', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.scopes)
end)
