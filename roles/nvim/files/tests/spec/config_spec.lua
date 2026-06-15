-- tests/spec/config_spec.lua
local function plugin_loaded(name)
  local ok, cfg = pcall(require, "lazy.core.config")
  if not ok then return false end
  local p = cfg.plugins[name]
  return p ~= nil and p._.loaded ~= nil
end

describe("config", function()
  it("sources without error and registers lazy", function()
    assert.is_true(pcall(require, "lazy.core.config"))
  end)

  it("loads core editor plugins eagerly", function()
    -- nvim-treesitter and treesitter-modules are lazy=false; flash is event-based.
    assert.is_true(plugin_loaded("nvim-treesitter"), "nvim-treesitter not loaded")
    assert.is_true(plugin_loaded("treesitter-modules.nvim"), "treesitter-modules not loaded")
  end)

  it("knows about flash.nvim", function()
    local cfg = require("lazy.core.config")
    assert.is_not_nil(cfg.plugins["flash.nvim"], "flash.nvim not in plugin list")
  end)
end)
