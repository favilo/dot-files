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
  -- Iron's maps live under <localleader> (comma). REPL interaction is inherently
  -- buffer/filetype-specific, and this keeps them clear of the <leader> clusters
  -- owned by Telescope (<leader>s*), LSP (<leader>c*), multicursors (<leader>m)
  -- and the shell-run map (<leader>rr).
  keymaps = {
    toggle_repl = "<localleader>rr", -- toggles the repl open and closed.
    -- If repl_open_command is a table as above, then the following keymaps are
    -- available
    -- toggle_repl_with_cmd_1 = "<localleader>rv",
    -- toggle_repl_with_cmd_2 = "<localleader>rh",
    restart_repl = "<localleader>rR", -- calls `IronRestart` to restart the repl
    send_motion = "<localleader>sc",
    visual_send = "<localleader>sc",
    send_file = "<localleader>sf",
    send_line = "<localleader>sl",
    send_paragraph = "<localleader>sp",
    send_until_cursor = "<localleader>su",
    send_mark = "<localleader>sm",
    send_code_block = "<localleader>sb",
    send_code_block_and_move = "<localleader>sn",
    mark_motion = "<localleader>mc",
    mark_visual = "<localleader>mc",
    remove_mark = "<localleader>md",
    cr = "<localleader>s<cr>",
    interrupt = "<localleader>s<space>",
    exit = "<localleader>sq",
    clear = "<localleader>cl",
  },
  ignore_blank_lines = true,

})
