-- tests/spec/telescope_spec.lua

describe("Telescope buffer mappings", function()
  -- Load telescope so its mappings are registered
  require("lazy").load({ plugins = { "telescope.nvim" } })

  it("maps <leader>pb to telescope buffers", function()
    local map_pb = vim.fn.maparg("<leader>pb", "n", false, true)
    assert.is_not_nil(map_pb)
    assert.is_truthy(map_pb.callback or map_pb.rhs)
    assert.are.equal("Telescope buffers", map_pb.desc)
  end)

  it("allows deleting buffers from <leader>pb with normal and insert commands", function()
    local map_pb = vim.fn.maparg("<leader>pb", "n", false, true)
    local cb = map_pb.callback
    assert.is_function(cb)

    -- Mock builtin.buffers
    local builtin = require("telescope.builtin")
    local original_buffers = builtin.buffers
    local captured_opts = nil
    builtin.buffers = function(opts)
      captured_opts = opts
    end

    -- Run the callback to capture the options passed to builtin.buffers
    cb()

    -- Restore original
    builtin.buffers = original_buffers

    -- Assert and guard on captured options
    assert.is_table(captured_opts)
    if not captured_opts then
      error("captured_opts is nil")
    end
    assert.is_function(captured_opts["attach_mappings"])

    -- Mock map function and actions.delete_buffer via its metatable __call
    local mapped = {}
    local map_fn = function(mode, key, fn)
      mapped[mode .. "_" .. key] = fn
    end

    local actions = require("telescope.actions")
    local delete_action = actions.delete_buffer
    local mt = getmetatable(delete_action)
    local original_call = mt.__call
    local deleted_bufnr = nil
    mt.__call = function(_, bufnr)
      deleted_bufnr = bufnr
    end

    -- Call attach_mappings with a mock prompt_bufnr (e.g., 42)
    local mock_prompt_bufnr = 42
    local attach_mappings_fn = captured_opts["attach_mappings"]
    if not attach_mappings_fn then
      error("attach_mappings is nil")
    end
    local res = attach_mappings_fn(mock_prompt_bufnr, map_fn)
    assert.is_true(res)

    -- Check mapped keys
    assert.is_function(mapped["i_<C-d>"])
    assert.is_function(mapped["n_<C-d>"])
    assert.is_function(mapped["n_d"])

    -- Verify that calling mapped functions triggers actions.delete_buffer with correct bufnr
    mapped["n_d"]()
    assert.are.equal(mock_prompt_bufnr, deleted_bufnr)

    -- Restore metatable
    mt.__call = original_call
  end)
end)
