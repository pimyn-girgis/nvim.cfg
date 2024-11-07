return {
  'mfussenegger/nvim-dap',
  keys = {
    { '<leader>dt', function() require('dap').toggle_breakpoint() end, desc = 'DAP: Toggle breakpoint', },
    { '<leader>dc', function() require('dap').continue() end,          desc = 'DAP: Continue', },
    { '<leader>do', function() require('dap').step_over() end,         desc = 'DAP: Step over', },
    { '<leader>di', function() require('dap').step_into() end,         desc = 'DAP: Step into', },
    { '<leader>dr', function() require('dap').repl.open() end,         desc = 'DAP: Open REPL', },
    { '<leader>ds', function() require('dap').stop() end,              desc = 'DAP: Stop', },
  },
}
