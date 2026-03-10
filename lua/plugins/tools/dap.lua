---@type LazySpec
return {
  "mfussenegger/nvim-dap",
  config = function(plugin, opts)
    require "astronvim.plugins.configs.nvim-dap"(plugin, opts)

    local dap = require "dap"
    dap.listeners.before.launch["save_all_buffers"] = function() vim.cmd "silent! wall" end
    dap.listeners.before.attach["save_all_buffers"] = function() vim.cmd "silent! wall" end
  end,
}
