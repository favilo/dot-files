-- Debug Adapter Protocol: nvim-dap and adapters.
return {
  {
    'mfussenegger/nvim-dap',
    lazy = false,
    config = function()
      require('plugins.dap')
    end,
  },
  -- use {
  --     'ldelossa/nvim-dap-projects',
  --     dependencies = { 'mfussenegger/nvim-dap' },
  -- }
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    }
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
  },

  { 'mfussenegger/nvim-dap-python', dependencies = { "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui" } },
  {
    'julianolf/nvim-dap-lldb',
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    opts = {},
  },
}
