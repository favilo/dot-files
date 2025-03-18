M = {}

local servers = require("plugins.lsp.servers").servers
local lsp_on_attach = function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }
  if client == nil then
    return
  end

  -- vim.notify("Attaching to " .. client.name, vim.log.levels.DEBUG)
  if client.name == "eslint" then
    vim.cmd.LspStop('eslint')
    return
  end

  if client.name == "yamlls" then
    client.server_capabilities.documentFormattingProvider = true
  end
  -- if client.name == "jsonls" then
  --   client.textDocument.completion.snippetSupport = true
  -- end

  vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "<leader>cD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "<leader>ci", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<leader>cl",
    function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
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

    local filter = function(local_client)
      vim.print(vim.inspect(local_client.name))
      return true
    end

    vim.lsp.buf.format({
      filter = filter,
      async = true,
      timeout_ms = 10000,
      formatting_options = formatting_options,
    })
  end, opts)
  vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
end


M.lsp_on_attach = lsp_on_attach
return M
