-- tests/spec/copilot_spec.lua

describe("Copilot Tab completion integration", function()
  -- Load blink.cmp so its configuration is loaded
  require("lazy").load({ plugins = { "blink.cmp" } })

  it("should retrieve the Tab action from blink configuration", function()
    local keymap = require("blink.cmp.config").keymap
    assert.is_not_nil(keymap)
    assert.is_not_nil(keymap["<Tab>"])
    assert.is_table(keymap["<Tab>"])
    assert.is_function(keymap["<Tab>"][1])
  end)

  it("should prioritize blink menu acceptance when blink menu is visible", function()
    local keymap = require("blink.cmp.config").keymap
    local tab_action = keymap["<Tab>"][1]

    -- Case 1: blink menu visible, snippet active
    local accept_called = false
    local select_and_accept_called = false
    local mock_cmp = {
      is_visible = function()
        return true
      end,
      snippet_active = function()
        return true
      end,
      accept = function()
        accept_called = true
        return true
      end,
      select_and_accept = function()
        select_and_accept_called = true
        return true
      end,
    }

    local res = tab_action(mock_cmp)
    assert.is_true(res)
    assert.is_true(accept_called)
    assert.is_false(select_and_accept_called)

    -- Case 2: blink menu visible, snippet not active
    accept_called = false
    mock_cmp.snippet_active = function()
      return false
    end
    res = tab_action(mock_cmp)
    assert.is_true(res)
    assert.is_false(accept_called)
    assert.is_true(select_and_accept_called)
  end)

  it("should accept Copilot suggestion when blink menu is closed but Copilot is visible", function()
    local keymap = require("blink.cmp.config").keymap
    local tab_action = keymap["<Tab>"][1]

    local mock_cmp = {
      is_visible = function()
        return false
      end,
    }

    -- Stub require("copilot.suggestion")
    local copilot_suggestion_accept_called = false
    package.loaded["copilot.suggestion"] = {
      is_visible = function()
        return true
      end,
      accept = function()
        copilot_suggestion_accept_called = true
        return true
      end,
    }

    local res = tab_action(mock_cmp)
    assert.is_true(res)
    assert.is_true(copilot_suggestion_accept_called)

    -- Cleanup package.loaded stub
    package.loaded["copilot.suggestion"] = nil
  end)

  it("should fall back when both blink menu and Copilot suggestion are not visible", function()
    local keymap = require("blink.cmp.config").keymap
    local tab_action = keymap["<Tab>"][1]

    local mock_cmp = {
      is_visible = function()
        return false
      end,
    }

    -- Stub require("copilot.suggestion") to return not visible
    package.loaded["copilot.suggestion"] = {
      is_visible = function()
        return false
      end,
    }

    local res = tab_action(mock_cmp)
    assert.is_false(res)

    -- Cleanup package.loaded stub
    package.loaded["copilot.suggestion"] = nil
  end)
end)
