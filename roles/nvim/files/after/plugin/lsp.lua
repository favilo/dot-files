vim.g.lsp_zero_extend_lspconfig = 0
vim.opt.exrc = true
local lsp = require('lsp-zero')

require('mason').setup({
    PATH = "append",
})

local mason_lspconfig = require('mason-lspconfig')

local venv_path = os.getenv('VIRTUAL_ENV')
local py_path = nil

if venv_path ~= nil then
    vim.notify("Found venv at " .. venv_path)
    py_path = venv_path .. '/bin/python'
end

local servers = {
    pylsp = {
        settings = {
            pylsp = {
                plugins = {
                    black = { enabled = true },
                    rope = { enabled = true },
                    mypy = {
                        enabled = true,
                        overrides = { "--python-executable", py_path, true },
                        report_progress = true,
                    },
                    isort = { enabled = true, profile = 'black' },
                    autopep8 = { enabled = false },
                    yapf = { enabled = false },
                    ruff = {
                        enabled = false,
                        formatEnabled = false,
                    },
                    pycodestyle = {
                        enabled = true,
                        maxLineLength = 140,
                    },
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
    },
    sumneko_lua = {
        settings = {
            Lua = {
                diagnostics = {
                    globals = { 'vim' },
                },
            },
        },
    },
    -- rust_analyzer = {
    --     settings = {
    --       ["rust-analyzer"] = {
    --           assist = {
    --               importGranularity = "module",
    --               importPrefix = "by_self",
    --           },
    --           checkOnSave = {
    --               command = "clippy",
    --           },
    --           cargo = {
    --               allFeatures = true,
    --               loadOutDirsFromCheck = true,
    --           },
    --           procMacro = {
    --               enable = true,
    --           },
    --       },
    --    },
    -- },
    jsonls = {
        formatting_options = {
            tabSize = 2,
        },
        settings = {
            json = {
                colorDecorators = {
                    enable = true,
                },
                format = {
                    enable = true,
                    keepLines = true,
                },
                validate = {
                    enable = true,
                },
                schemaDownload = {
                    enable = true,
                },
                schemas = require("schemastore").json.schemas(
                -- {
                --     select = {
                --         "package.json",
                --         ".eslintrc",
                --         "tsconfig.json",
                --         "*.docnav.vson",
                --     },
                -- }
                ),
            },
        },
        -- → json.maxItemsComputed        default: 5000
        -- → json.schemaDownload.enable   default: true
        -- → json.schemas
        -- → json.trace.server            default: "off"
    },
    yamlls = {
        formatting_options = {
            tabSize = 2,
        },
        settings = {
            yaml = {
                schemaStore = {
                    enable = false,
                    url = "",
                },
                schemas = require("schemastore").yaml.schemas()
            },
        },
    },
}

local client_capabilities = vim.lsp.protocol.make_client_capabilities()
client_capabilities = require('cmp_nvim_lsp').default_capabilities(client_capabilities)

lsp.preset('recommended')

local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and
        vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") ==
        nil
end

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local luasnip = require("luasnip")

local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<Tab>'] = nil,
    ['<S-Tab>'] = nil,
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<M-space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<TAB>'] = cmp.mapping(function(fallback)
        local suggestion = require('supermaven-nvim.completion_preview')
        if suggestion.has_suggestion() then
            suggestion.on_accept_suggestion()
            -- Copilot stuff for if I go back.
            -- if require("copilot.suggestion").is_visible() then
            --     require("copilot.suggestion").accept()
        elseif cmp.visible() then
            cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
        elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
        elseif has_words_before() then
            cmp.complete()
        else
            fallback()
        end
    end),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

cmp.setup({
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    sources = {
        { name = "supermaven" },
        { name = "nvim_lsp" },
        { name = "digraphs" },
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

    if client.name == "yamlls" then
        client.server_capabilities.documentFormattingProvider = true
    end
    if client.name == "jsonls" then
        client.server_capabilities.snippetSupport = true
    end

    vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "<leader>cD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "<leader>ci", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>cl",
        function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(), opts)
        end,
        opts)
    vim.keymap.set({ "n", "v" }, "<leader>cws", vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, opts)
    vim.keymap.set({ "v", "n" }, "<leader>ca", require('actions-preview').code_actions, opts)
    vim.keymap.set("n", "<leader>cR", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<leader>cf", function()
        local formatting_options = nil
        if servers[client.name] and servers[client.name].formatting_options then
            formatting_options = servers[client.name].formatting_options
        else
            formatting_options = {}
        end

        local filter = function(client)
            vim.print(vim.inspect(client.name))
            return true
        end
        vim.lsp.buf.format({
            filter = filter,
            async = true,
            formatting_options = formatting_options,
        })
    end, opts)
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
end)

mason_lspconfig.setup {
    -- Replace the language servers listed here
    -- with the ones you want to install
    ensure_installed = {
        'ts_ls',
        'eslint',
        'lua_ls',
        -- Handled by rustaceanvim
        -- 'rust_analyzer',
        'pylsp',
        'clangd',
        'jsonls',
        'yamlls',
        -- 'cpptools',
        -- 'codelldb',
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
        if server_name == 'rust-analyzer' then
            return true
        end
        local config = servers[server_name]
        if config == nil then
            config = {}
        end

        config.capabilitis = client_capabilities
        if config.on_attach ~= nil then
            config.on_attach = lsp.on_attach
        end

        require('lspconfig')[server_name].setup(config)
    end,
}

vim.diagnostic.config({
    virtual_text = true,
})
require('lspconfig').glslls.setup {}

for _, method in ipairs({ "textDocument/diagnostic", "workspace/diagnostic" }) do
    local default_diagnostic_handler = vim.lsp.handlers[method]
    vim.lsp.handlers[method] = function(err, result, context, config)
        if err ~= nil and err.code == -32802 then
            return
        end
        return default_diagnostic_handler(err, result, context, config)
    end
end
