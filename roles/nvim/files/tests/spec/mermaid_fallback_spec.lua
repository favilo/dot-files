describe("Zellij Mermaid fallback", function()
  local original_zellij = vim.env.ZELLIJ
  local original_wezterm_pane = vim.env.WEZTERM_PANE
  local original_kitty_pid = vim.env.KITTY_PID

  before_each(function()
    vim.env.ZELLIJ = "0"
    vim.env.WEZTERM_PANE = nil
    vim.env.KITTY_PID = nil
    vim.cmd("enew!")
    vim.cmd("setfiletype markdown")
  end)

  after_each(function()
    vim.env.ZELLIJ = original_zellij
    vim.env.WEZTERM_PANE = original_wezterm_pane
    vim.env.KITTY_PID = original_kitty_pid
    vim.cmd("bwipeout!")
  end)

  it("registers an external viewer command for Markdown buffers", function()
    assert.equals(2, vim.fn.exists(":MermaidOpen"))
  end)

  it("maps leader mo to the external viewer command", function()
    local mapping = vim.fn.maparg("<leader>mo", "n", false, true)
    assert.equals("<cmd>MermaidOpen<cr>", mapping.rhs)
  end)

  it("does not register the fallback when WezTerm can render through Sixel", function()
    vim.cmd("bwipeout!")
    vim.env.WEZTERM_PANE = "123"
    vim.cmd("enew!")
    vim.cmd("setfiletype markdown")

    assert.equals(0, vim.fn.exists(":MermaidOpen"))
  end)

end)
