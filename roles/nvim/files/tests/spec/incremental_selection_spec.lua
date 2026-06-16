-- tests/spec/incremental_selection_spec.lua

-- Feed keys through the mapping engine, synchronously, with remaps applied.
-- The "x" flag is load-bearing: it flushes the typeahead and executes the
-- buffer-local x-mode maps (created on FileType by treesitter-modules) right
-- now, so the selection has actually grown/shrunk by the time this returns.
-- "m" (remap) is the default; "n" would skip the mappings we are testing.
-- Headless nvim_input did NOT fire these buffer-local maps in this harness;
-- the "mtx" variant likewise did not flush synchronously, hence plain "x".
local function feed(keys)
  local codes = vim.api.nvim_replace_termcodes(keys, true, false, true)
  vim.api.nvim_feedkeys(codes, "x", false)
end

-- Length (in chars on a single line) of the current visual selection.
-- Must be called while still in visual mode.
local function visual_len()
  local a = vim.fn.getpos("v") -- {bufnum, lnum, col, off}
  local b = vim.fn.getpos(".")
  if a[2] ~= b[2] then
    -- multi-line: approximate by line span so growth is still detectable
    return (math.abs(b[2] - a[2]) + 1) * 10000
  end
  return math.abs(b[3] - a[3]) + 1
end

-- A parser binary on the runtimepath is the reliable signal that a tree can be
-- built (Neovim bundles `lua`; nvim-treesitter installs others).
-- `vim.treesitter.language.add` is not a dependable availability check.
local function has_lua_parser()
  return #vim.api.nvim_get_runtime_file("parser/lua.*", false) > 0
end

local function open_lua_buffer()
  vim.cmd("enew!")
  vim.bo.filetype = "lua" -- fires FileType -> treesitter-modules attaches v/V
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { "local foobar = 1" })
  -- Best-effort parse; tolerate a missing parser so this never errors the
  -- mapping test. The behavioral test gates on has_lua_parser() instead.
  pcall(function()
    vim.treesitter.get_parser(0, "lua"):parse()
  end)
end

describe("treesitter incremental selection", function()
  it("maps v/V in visual mode to treesitter-modules", function()
    if not has_lua_parser() then
      pending("lua treesitter parser not installed")
      return
    end
    open_lua_buffer()
    local v = vim.fn.maparg("v", "x", false, true)
    local V = vim.fn.maparg("V", "x", false, true)
    assert.are.equal("Increment selection to named node", v.desc)
    assert.are.equal("Shrink selection to previous named node", V.desc)
  end)

  it("grows selection with v and shrinks with V", function()
    if not has_lua_parser() then
      pending("lua treesitter parser not installed")
      return
    end
    open_lua_buffer()
    -- cursor onto the identifier `foobar` (line 1, col 7; 0-indexed col 6)
    vim.api.nvim_win_set_cursor(0, { 1, 6 })

    feed("v") -- native visual, 1 char
    local base = visual_len()

    feed("v") -- node_incremental -> the identifier node
    local grown = visual_len()
    assert.is_true(grown > base, ("expected grow: base=%d grown=%d"):format(base, grown))

    feed("v") -- grow again to an enclosing node
    local grown2 = visual_len()
    assert.is_true(grown2 >= grown, ("expected grow2: %d >= %d"):format(grown2, grown))

    feed("V") -- node_decremental -> shrink back
    local shrunk = visual_len()
    assert.is_true(shrunk < grown2, ("expected shrink: %d < %d"):format(shrunk, grown2))

    feed("<Esc>")
  end)
end)
