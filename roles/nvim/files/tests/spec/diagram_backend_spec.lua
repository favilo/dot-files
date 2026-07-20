describe("Markdown diagram backends", function()
	local environment = { "WEZTERM_PANE", "TERM", "KITTY_PID", "ZELLIJ" }
	local original_environment = {}

	local function set_environment(values)
		for _, name in ipairs(environment) do
			vim.env[name] = values[name]
		end
	end

	before_each(function()
		for _, name in ipairs(environment) do
			original_environment[name] = vim.env[name]
		end
		set_environment({})
	end)

	after_each(function()
		set_environment(original_environment)
	end)

	it("uses Sixel for WezTerm, including inside Zellij", function()
		set_environment({ WEZTERM_PANE = "123", ZELLIJ = "0" })

		local plugins = require("plugins.spec.diagram")
		assert.is_true(plugins[1].cond())
		assert.is_true(plugins[2].cond())
		assert.equals("sixel", plugins[1].opts().backend)
	end)

	it("uses Kitty only outside Zellij", function()
		set_environment({ TERM = "xterm-kitty" })

		local plugins = require("plugins.spec.diagram")
		assert.is_true(plugins[1].cond())
		assert.equals("kitty", plugins[1].opts().backend)

		set_environment({ TERM = "xterm-kitty", ZELLIJ = "0" })
		assert.is_false(plugins[1].cond())
		assert.is_false(plugins[2].cond())
	end)

end)
