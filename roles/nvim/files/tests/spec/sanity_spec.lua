-- tests/spec/sanity_spec.lua
describe("test harness", function()
  it("runs lua assertions", function()
    assert.are.equal(2, 1 + 1)
  end)

  it("has the real config on the runtimepath", function()
    -- config-local module from the repo must be requireable
    assert.has_no.errors(function()
      require("config.options")
      require("config.colors")
      require("config.filetypes")
      require("config.keymaps")
      require("config.lazy")
    end)
  end)
end)
