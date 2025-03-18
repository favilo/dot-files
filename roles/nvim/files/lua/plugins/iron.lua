local iron = require("iron.core")
local view = require("iron.view")
local common = require("iron.fts.common")

iron.setup({
  config = {
    -- Whether a repl should be discarded or not
    scratch_repl = true,
    -- Your repl definitions come here
    repl_definition = {
      sh = {
        -- Can be a table or a function that
        -- returns a table (see below)
        command = { "zsh" }
      },
      python = {
        command = { "ipython", "--no-autoindent" },
        format = common.bracketed_paste_python,
        block_deviders = { "# %%", "#%%" },
      },
      lua = require("iron.fts.lua"),
    },
    -- set the file type of the newly created repl to ft
    -- bufnr is the buffer id of the REPL and ft is the filetype of the
    -- language being used for the REPL.
    repl_filetype = function(bufnr, ft)
      return ft
      -- or return a string name such as the following
      -- return "iron"
    end,
    -- How the repl window will be displayed
    -- See below for more information
    repl_open_cmd = view.split.vertical.rightbelow("%25"),
  },
  keymaps = {
    toggle_repl = "<leader>rr", -- toggles the repl open and closed.
    -- If repl_open_command is a table as above, then the following keymaps are
    -- available
    -- toggle_repl_with_cmd_1 = "<leader>rv",
    -- toggle_repl_with_cmd_2 = "<leader>rh",
    restart_repl = "<leader>rR", -- calls `IronRestart` to restart the repl
    send_motion = "<leader>sc",
    visual_send = "<leader>sc",
    send_file = "<leader>sf",
    send_line = "<leader>sl",
    send_paragraph = "<leader>sp",
    send_until_cursor = "<leader>su",
    send_mark = "<leader>sm",
    send_code_block = "<leader>sb",
    send_code_block_and_move = "<leader>sn",
    mark_motion = "<leader>mc",
    mark_visual = "<leader>mc",
    remove_mark = "<leader>md",
    cr = "<leader>s<cr>",
    interrupt = "<leader>s<space>",
    exit = "<leader>sq",
    clear = "<leader>cl",
  },
  ignore_blank_lines = true,

})
