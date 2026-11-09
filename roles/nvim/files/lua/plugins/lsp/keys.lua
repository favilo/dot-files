local M = {}

local lsp_on_attach = function(client, event)
  -- vim.notify("Attaching to " .. client.name .. " Lsp server")
  local bufnr = event.buf
  local opts = { buffer = bufnr, remap = false }
  -- Buffer-local map that always carries a description (for which-key / the
  -- <leader>fk Telescope keymap picker).
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
  end
  if client == nil then
    return
  end

  -- vim.notify("Attaching to " .. client.name, vim.log.levels.DEBUG)
  if client.name == "eslint" then
    vim.cmd.LspStop("eslint")
    return
  end

  if client.name == "yamlls" then
    client.server_capabilities.documentFormattingProvider = true
  end

  -- if client.name == "jsonls" then
  --   client.textDocument.completion.snippetSupport = true
  -- end
  --
  if client:supports_method("textDocument/implementation") then
    map("n", "<leader>ci", vim.lsp.buf.implementation, "LSP: go to implementation")
  end

  if client:supports_method("textDocument/completion") then
    vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
  end

  map("n", "<leader>cd", vim.lsp.buf.definition, "LSP: go to definition")
  map("n", "<leader>cD", vim.lsp.buf.declaration, "LSP: go to declaration")
  map("n", "K", function()
    vim.lsp.buf.hover({ border = "rounded" })
  end, "LSP: hover docs")
  map("n", "<leader>cl", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
  end, "LSP: toggle inlay hints")
  map({ "n", "v" }, "<leader>cws", vim.lsp.buf.workspace_symbol, "LSP: workspace symbols")
  map("n", "]d", function()
    vim.diagnostic.jump({ count = 1, float = true })
  end, "Diagnostic: next")
  map("n", "[d", function()
    vim.diagnostic.jump({ count = -1, float = true })
  end, "Diagnostic: prev")
  map("n", "<leader>dd", vim.diagnostic.open_float, "Diagnostic: show float")
  map({ "v", "n" }, "<leader>ca", require("actions-preview").code_actions, "LSP: code actions")
  map("n", "<leader>cR", vim.lsp.buf.references, "LSP: references")
  map("n", "<leader>cr", vim.lsp.buf.rename, "LSP: rename symbol")
  -- Buffer-local map wins over conform's global <leader>cf. Call conform here too,
  -- so Markdown still reaches mdformat when an LSP (for example Obsidian) is attached.
  -- lsp_format = "fallback" keeps LSP formatting for filetypes conform does not own.
  map({ "n", "v" }, "<leader>cf", function()
    require("conform").format({ async = true, lsp_format = "fallback", timeout_ms = 10000 })
  end, "Format buffer")
  map("i", "<C-h>", function()
    vim.lsp.buf.signature_help({ border = "rounded" })
  end, "LSP: signature help (insert mode)")
end

M.lsp_on_attach = lsp_on_attach
return M
