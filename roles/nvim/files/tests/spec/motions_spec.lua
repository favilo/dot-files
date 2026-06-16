-- tests/spec/motions_spec.lua

local function maparg(lhs, mode)
  return vim.fn.maparg(lhs, mode, false, true) or {}
end

describe("flash + surround coexistence", function()
  it("flash s is mapped in normal, visual, operator", function()
    -- lazy registers keymap stubs from the `keys` spec even before flash loads.
    for _, mode in ipairs({ "n", "x", "o" }) do
      local m = maparg("s", mode)
      assert.is_truthy(
        m.callback or m.rhs,
        "flash s should be mapped in mode '"
          .. mode
          .. "'; lazy registers the "
          .. "flash keys-spec stub for s in mode = { 'n', 'x', 'o' } before flash loads."
      )
    end
  end)

  it("flash S is mapped in normal + operator only (not visual)", function()
    assert.are.equal(
      "Flash Treesitter",
      maparg("S", "n").desc,
      "normal-mode S should be the flash treesitter mapping (desc 'Flash Treesitter'); "
        .. "the flash keys spec must map S in mode = { 'n', 'o' }."
    )
    assert.are.equal(
      "Flash Treesitter",
      maparg("S", "o").desc,
      "operator-mode S should be the flash treesitter mapping (desc 'Flash Treesitter'); "
        .. "the flash keys spec must map S in mode = { 'n', 'o' }."
    )
    -- visual-mode S must NOT be the flash mapping, or it clobbers vim-surround's
    -- visual S (e.g. `S(` to wrap a selection). Keep flash S in { "n", "o" } only.
    assert.is_not.equal(
      "Flash Treesitter",
      maparg("S", "x").desc,
      "flash claimed visual-mode S; this clobbers vim-surround's visual S "
        .. "(e.g. `S(`). Flash S must be mode = { 'n', 'o' }, not include 'x'."
    )
  end)

  it("vim-surround keeps visual-mode S", function()
    require("lazy").load({ plugins = { "vim-surround" } })
    local m = maparg("S", "x")
    assert.is_truthy(
      m.rhs,
      "vim-surround should map visual-mode S to a <Plug> rhs (expected <Plug>VSurround); "
        .. "got no rhs, so something clobbered surround's visual S."
    )
    assert.is_truthy(
      m.rhs:match("Surround"),
      "vim-surround's visual-mode S should target a Surround <Plug> (expected <Plug>VSurround); "
        .. "got rhs = '"
        .. tostring(m.rhs)
        .. "', which is not a surround mapping."
    )
  end)
end)
