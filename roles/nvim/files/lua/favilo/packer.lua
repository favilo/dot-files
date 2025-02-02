-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]
--
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
    -- Packer can manage itself
    use { 'wbthomason/packer.nvim' }

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.4',
        -- or                            , branch = '0.1.x',
        requires = {
            { 'nvim-lua/plenary.nvim' },
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
            },
            { "nvim-telescope/telescope-live-grep-args.nvim" },
        }
    }

    use { 'bluz71/vim-nightfly-colors' }

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
    use { 'nvim-treesitter/playground' }
    use { 'mbbill/undotree' }
    use {
        "ahmedkhalf/project.nvim",
        config = function()
            require("project_nvim").setup {
                -- Methods of detecting the root directory. **"lsp"** uses the native neovim
                -- lsp, while **"pattern"** uses vim-rooter like glob pattern matching. Here
                -- order matters: if one is not detected, the other is used as fallback. You
                -- can also delete or rearangne the detection methods.
                detection_methods = { "pattern", "lsp", },
                patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn" },
                exclude_dirs = { "~/.cargo/*" },

                show_hidden = true,

                -- When set to false, you will get a message when project.nvim changes your
                -- directory.
                silent_chdir = false,

                -- What scope to change the directory, valid options are
                -- * global (default)
                -- * tab
                -- * win
                scope_chdir = 'win',
            }
        end
    }
    use { 'chaoren/vim-wordmotion' }
    use { 'tpope/vim-rhubarb' }
    use { 'tpope/vim-surround' }
    use { 'tpope/vim-commentary' }
    use { 'tpope/vim-dadbod' }
    use { 'tpope/vim-dispatch' }
    use { 'tpope/vim-endwise' }
    use { 'tpope/vim-speeddating' }
    use { 'tpope/vim-sensible' }
    use { 'Townk/vim-autoclose' }

    use { 'NeogitOrg/neogit',
        requires = {
            'nvim-lua/plenary.nvim',
            "sindrets/diffview.nvim",
            'nvim-telescope/telescope.nvim',
        },
        -- config = true,
    }

    use { 'lewis6991/gitsigns.nvim' }

    use {
        'saecki/crates.nvim',
        event = { "BufRead Cargo.toml" },
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('crates').setup()
        end,
    }

    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            {
                'williamboman/mason-lspconfig.nvim',
                run = ':PylspInstall python-lsp-black pyls-isort pylsp-rope',
            },
            { "lukas-reineke/lsp-format.nvim" },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            {
                'L3MON4D3/LuaSnip',
                version = "v2.*",
                build = "make install_jsregexp",
            },
            { 'rafamadriz/friendly-snippets' },

            -- LSP Extras
            { 'b0o/schemastore.nvim' },
        }
    }

    use { 'ray-x/lsp_signature.nvim' }
    use { 'aznhe21/actions-preview.nvim' }
    -- use {
    --     'weilbith/nvim-code-action-menu',
    --     cmd = 'CodeActionMenu',
    -- }
    use { 'mrjones2014/op.nvim', run = 'make install' }
    use { 'averms/black-nvim', cmd = 'UpdateRemotePlugins' }

    use {
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require("todo-comments").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    }

    use { 'simrat39/rust-tools.nvim' }

    use { 'nvim-lua/plenary.nvim' }

    use { 'nvim-telescope/telescope-project.nvim' }

    use {
        "someone-stole-my-name/yaml-companion.nvim",
        requires = {
            { "neovim/nvim-lspconfig" },
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope.nvim" },
        },
        config = function()
            require("telescope").load_extension("yaml_schema")
        end,
    }

    -- use {
    --     "zbirenbaum/copilot.lua",
    --     cmd = "Copilot",
    --     event = "InsertEnter",
    --     dependencies = { "hrsh7th/nvim-cmp" },
    --     config = function()
    --         require("copilot").setup({
    --             panel = { enabled = true },
    --             suggestion = {
    --                 enabled = true,
    --                 auto_trigger = true,
    --                 hide_during_completion = true,
    --                 keymap = {
    --                     accept = "M-l",
    --                     accept_word = false,
    --                     accept_line = false,
    --                     next = "<C-space>",
    --                     prev = "<C-S-space>",
    --                     dismiss = "<C-]>",
    --                 },
    --             },
    --             filetypes = {
    --                 yaml = true,
    --                 python = true,
    --                 lua = true,
    --             }
    --         })

    --         local suggestion = require("copilot.suggestion")
    --         local function toggle_auto_trigger()
    --             local auto_trig = vim.b.copilot_suggestion_auto_trigger
    --             if auto_trig == nil or auto_trig == true then
    --                 vim.notify("Copilot auto-suggestion disabled")
    --                 suggestion.dismiss()
    --             else
    --                 vim.notify("Copilot auto-suggestion enabled")
    --                 suggestion.next()
    --             end
    --             suggestion.toggle_auto_trigger()
    --         end

    --         vim.keymap.set({ "i", "n", "v" }, "<A-space>", function() suggestion.toggle_auto_trigger() end,
    --             { desc = "Toggle auto trigger" })
    --         vim.keymap.set("n", "<leader>cT", "<cmd>Copilot toggle", { desc = "Copilot toggle" })
    --         vim.keymap.set("n", "<leader>cs", toggle_auto_trigger, { desc = "Copilot Suggestion toggle" })
    --         vim.keymap.set("i", "<C-e>", toggle_auto_trigger, { desc = "Copilot Suggestion toggle" })
    --     end,
    -- }

    -- TODO: Think about using supermaven instead of copilot
    use {
        "supermaven-inc/supermaven-nvim",
        config = function()
            require("supermaven-nvim").setup({
                keymap = {
                    accept_suggestion = "<CR>",
                    clear_suggestion = "<C-]>",
                    accept_word = "<C-j>",
                },

            })
        end,
    }

    use { 'nanotee/zoxide.vim' }

    use {
        "stevearc/oil.nvim",
        requires = {
            "nvim-tree/nvim-web-devicons",
        },
        -- config = function()
        --     require("oil").setup()
        -- end,
    }

    use { 'lambdalisue/fern.vim' }
    use { 'lambdalisue/suda.vim' }

    -- use {
    --     "epwalsh/obsidian.nvim",
    --     tag = "*", -- recommended, use latest release instead of latest commit
    --     requires = {
    --         -- Required.
    --         "nvim-lua/plenary.nvim",

    --         -- see below for full list of optional dependencies 👇
    --     },
    --     config = function()
    --         require("obsidian").setup({
    --             workspaces = {
    --                 {
    --                     name = "personal",
    --                     path = "~/Obsidian/Main Vault",
    --                 },
    --                 -- {
    --                 --     name = "work",
    --                 --     path = "~/vaults/work",
    --                 -- },
    --             },

    --             -- see below for full list of options 👇
    --             notes_subdir = "working-notes",
    --             log_level = vim.log.levels.INFO,
    --             daily_notes = {
    --                 folder = "tracking/dailies",
    --                 date_format = "%Y-%m-%d",
    --                 template = "templates/daily-update",
    --             },
    --             completion = {
    --                 nvim_cmp = true,
    --                 min_chars = 2,
    --             },

    --             -- Optional, configure key mappings. These are the defaults. If you don't want to set any keymappings this
    --             -- way then set 'mappings = {}'.
    --             mappings = {
    --                 -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
    --                 ["gf"] = {
    --                     action = function()
    --                         return require("obsidian").util.gf_passthrough()
    --                     end,
    --                     opts = { noremap = false, expr = true, buffer = true },
    --                 },
    --                 -- Toggle check-boxes.
    --                 ["<leader>ch"] = {
    --                     action = function()
    --                         return require("obsidian").util.toggle_checkbox()
    --                     end,
    --                     opts = { buffer = true },
    --                 },
    --             },


    --         })
    --     end,
    -- }

    use {
        "epwalsh/pomo.nvim",
        tag = "*", -- Recommended, use latest release instead of latest commit
        requires = {
            -- Optional, but highly recommended if you want to use the "Default" timer
            "rcarriga/nvim-notify",
        },
        config = function()
            require("pomo").setup({
                -- See below for full list of options 👇
            })
        end,
    }

    -- DAP plugins
    use { 'mfussenegger/nvim-dap' }
    -- use {
    --     'ldelossa/nvim-dap-projects',
    --     requires = { 'mfussenegger/nvim-dap' },
    -- }
    use { 'folke/neodev.nvim' }
    use {
        "rcarriga/nvim-dap-ui",
        requires = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        }
    }

    use { 'mfussenegger/nvim-dap-python', requires = { "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui" } }
    use { 'almo7aya/openingh.nvim' }

    use {
        "mrcjkb/rustaceanvim",
        version = "^5",
        config = function()
            vim.print("Setting up rustaceanvim")
            vim.g.rustaceanvim = function()
                -- Update this path
                local codelldb = require('mason-registry').get_package('codelldb')
                local extension_path = codelldb:get_install_path() .. '/extension/'
                local codelldb_path = extension_path .. 'adapter/codelldb'
                local liblldb_path = extension_path .. 'lldb/lib/liblldb'
                local this_os = vim.uv.os_uname().sysname;

                -- The path is different on Windows
                if this_os:find "Windows" then
                    codelldb_path = extension_path .. "adapter\\codelldb.exe"
                    liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
                else
                    -- The liblldb extension is .so for Linux and .dylib for MacOS
                    liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
                end

                local cfg = require('rustaceanvim.config')
                return {
                    crate_graph = {
                        backend = "svg",
                        output = "target/crate-graph.svg",
                    },
                    server = {
                        ra_multiplex = {
                            enable = true,
                        },
                    },
                    dap = {
                        adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
                    },
                }
            end
        end,
    }

    use {
        "nvim-neotest/neotest",
        requires = {
            "nvim-neotest/nvim-nio",
            "nvim-neotest/neotest-python",
            "nvim-neotest/neotest-plenary",
            "nvim-neotest/neotest-vim-test",
            -- "rouge8/neotest-rust",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter"
        }
    }

    use { 'sk1418/HowMuch' }
    use { 'diepm/vim-rest-console' }

    -- use { 'airblade/vim-rooter' }
    use {
        "hedyhli/outline.nvim",
        config = function()
            -- Example mapping to toggle outline
            vim.keymap.set("n", "<leader>o",
                function() require("outline").toggle({ placement = "topleft", focus_outline = false }) end,
                { desc = "Toggle Outline" })
            vim.keymap.set("n", "<leader>O", function() require("outline").focus_toggle() end, { desc = "Focus Outline" })

            require("outline").setup {
                -- Your setup opts here (leave empty to use defaults)
            }
        end,
    }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
