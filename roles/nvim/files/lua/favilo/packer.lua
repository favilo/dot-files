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
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                config = function()
                    require('telescope').load_extension('fzf')
                end,
            },
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
                detection_methods = { "lsp", "pattern" },
                patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },

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
        'williamboman/mason.nvim',
    }

    use {
        'williamboman/mason-lspconfig.nvim',
        run = ':PylspInstall python-lsp-black',
    }
    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
            { "lukas-reineke/lsp-format.nvim" },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    }

    use { 'ray-x/lsp_signature.nvim' }
    use {
        'weilbith/nvim-code-action-menu',
        cmd = 'CodeActionMenu',
    }
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

    use {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                },
                filetypes = {
                    yaml = true,
                }
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
        "nvim-neotest/neotest",
        requires = {
            "nvim-neotest/nvim-nio",
            "nvim-neotest/neotest-python",
            "nvim-neotest/neotest-plenary",
            "nvim-neotest/neotest-vim-test",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter"
        }
    }
end)
