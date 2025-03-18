local capabilities = require("plugins.lsp.servers").capabilities
local lsp_on_attach = require("plugins.lsp.keys").lsp_on_attach

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
    dap = {
      adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
      autoload_configurations = true,
    },
    crate_graph = {
      backend = "svg",
      output = "target/crate-graph.svg",
    },
    tools = {
      enable_clippy = true,
    },
    server = {
      standalone = false,
      on_attach = function(client, bufnr)
        lsp_on_attach(client, bufnr)
        vim.keymap.set('n', '<leader>rm', '<cmd>RustLsp expandMacro<CR>',
          { buffer = bufnr, desc = " Rust expandMacro" })
      end,
      capabilities = capabilities,
      auto_attach = true,
      ra_multiplex = {
        enable = true,
      },
      default_settings = {
        ['rust-analyzer'] = {
          assist = {
            emitMustUse = true,
          },
          checkOnSave = true,
          check = {
            command = "clippy",
          },
          cargo = {
            allFeatures = true,
          },
          completion = {
            autoself = {
              enable = true,
            },
          },
          procMacro = {
            enable = true,
          },
        },
      },
    },
  }
end
