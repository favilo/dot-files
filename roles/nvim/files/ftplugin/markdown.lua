vim.wo.conceallevel = (vim.bo.readonly or vim.bo.buftype == "nofile") and 2 or 0

if vim.env.ZELLIJ == nil or vim.b.mermaid_external_viewer_configured then return end

vim.b.mermaid_external_viewer_configured = true

local function mermaid_source_at_cursor()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local cursor_row = vim.api.nvim_win_get_cursor(0)[1]
  local opening_row

  for row = cursor_row, 1, -1 do
    local line = lines[row]
    if line:match("^%s*```") then
      if line:match("^%s*```%s*mermaid%s*$") then
        opening_row = row
        break
      end
      return nil
    end
  end

  if not opening_row then return nil end

  local source = {}
  for row = opening_row + 1, #lines do
    local line = lines[row]
    if line:match("^%s*```%s*$") then return table.concat(source, "\n") end
    table.insert(source, line)
  end
end

local function open_mermaid_at_cursor()
  local source = mermaid_source_at_cursor()
  if not source then
    vim.notify("Place the cursor inside a Mermaid code fence", vim.log.levels.WARN, { title = "Mermaid" })
    return
  end

  if vim.fn.executable("mmdc") == 0 then
    vim.notify("mmdc is required to render Mermaid diagrams", vim.log.levels.ERROR, { title = "Mermaid" })
    return
  end

  local cache_dir = vim.fn.stdpath("cache") .. "/mermaid"
  vim.fn.mkdir(cache_dir, "p")

  local input_path = vim.fn.tempname()
  local output_path = cache_dir .. "/" .. vim.fn.sha256(source) .. ".png"
  vim.fn.writefile(vim.split(source, "\n"), input_path)

  local stderr = {}
  vim.fn.jobstart({ "mmdc", "-i", input_path, "-o", output_path, "-t", "dark" }, {
    on_stderr = function(_, data)
      for _, line in ipairs(data) do
        if line ~= "" then
          table.insert(stderr, line)
        end
      end
    end,
    on_exit = function(_, exit_code)
      vim.schedule(function()
        vim.fn.delete(input_path)
        if exit_code ~= 0 or vim.fn.filereadable(output_path) == 0 then
          local message = #stderr > 0 and table.concat(stderr, "\n") or "mmdc exited with code " .. exit_code
          vim.notify(message, vim.log.levels.ERROR, { title = "Mermaid render failed" })
          return
        end
        vim.ui.open(output_path)
      end)
    end,
  })
end

vim.api.nvim_buf_create_user_command(0, "MermaidOpen", open_mermaid_at_cursor, {
  desc = "Render Mermaid fence at cursor",
})

vim.keymap.set("n", "<leader>mo", "<cmd>MermaidOpen<cr>", {
  buffer = true,
  desc = "Open Mermaid diagram",
})
