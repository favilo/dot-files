vim.g.lsp_zero_extend_lspconfig = 0
local lsp = require('lsp-zero')

require('mason').setup()
local mason_lspconfig = require('mason-lspconfig')

local servers = {
    pylsp = {
        pylsp = {
            plugins = {
                black = { enabled = true },
                rope = { enabled = true },
                mypy = {
                    enabled = true,
                },
                isort = { enabled = true, profile = 'black' },
                autopep8 = { enabled = false },
                yapf = { enabled = false },
                ruff = {
                    enabled = false,
                    formatEnabled = false,
                },
                pycodestyle = { enabled = false },
                pyflakes = { enabled = false },
                mccabe = { enabled = false },
                flake8 = {
                    enabled = false,
                    ignore = { 'E501' },
                    maxLineLength = 140,
                },
            },
        },
    },
    sumneko_lua = {
        Lua = {
            diagnostics = {
                globals = { 'vim' },
            },
        },
    }
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

lsp.preset('recommended')

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
})

-- cmp_mappings['<Tab>'] = nil
-- cmp_mappings['<S-Tab>'] = nil

cmp.setup({
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    sources = {
        { name = "nvim_lsp" },
    },
    mapping = cmp_mappings
})

lsp.set_preferences({
    suggest_lsp_servers = true,
    setup_servers_on_start = true,
    set_lsp_keymaps = true,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    if client.name == "eslint" then
        vim.cmd.LspStop('eslint')
        return
    end

    vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "<leader>cD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "<leader>ci", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set({ "n", "v" }, "<leader>cws", vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, opts)
    vim.keymap.set({ "v", "n" }, "<leader>ca", require('actions-preview').code_actions, opts)
    vim.keymap.set("n", "<leader>cR", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, opts)
    vim.keymap.set("v", "<leader>cf", vim.lsp.buf.format, opts)
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
end)

mason_lspconfig.setup {
    -- Replace the language servers listed here
    -- with the ones you want to install
    ensure_installed = {
        'tsserver',
        'eslint',
        'lua_ls',
        'rust_analyzer',
        'pylsp',
        'clangd',
    },
}

lsp.setup()
lsp.extend_lspconfig()

require("actions-preview").setup {
    highlight_command = {
        require("actions-preview.highlight").diff_so_fancy(),
    },

    backend = { "telescope" },
    telescope = vim.tbl_extend(
        "force",
        -- telescope theme: https://github.com/nvim-telescope/telescope.nvim#themes
        require("telescope.themes").get_dropdown(),
        -- a table for customizing content
        {
            -- a function to make a table containing the values to be displayed.
            -- fun(action: Action): { title: string, client_name: string|nil }
            make_value = nil,

            -- a function to make a function to be used in `display` of a entry.
            -- see also `:h telescope.make_entry` and `:h telescope.pickers.entry_display`.
            -- fun(values: { index: integer, action: Action, title: string, client_name: string }[]): function
            make_make_display = nil,
        }
    )
}

mason_lspconfig.setup_handlers {
    function(server_name)
        require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = lsp.on_attach,
            settings = servers[server_name],
        }
    end,
}

vim.diagnostic.config({
    virtual_text = true,
})
require('lspconfig').glslls.setup {}
