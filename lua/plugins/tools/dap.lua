-- DAP (Debug Adapter Protocol) global configuration
-- Auto-save all buffers before debugging

---@type LazySpec
return {
  "mfussenegger/nvim-dap",
  config = function()
    local dap = require("dap")

    -- Auto-save all buffers before starting debug session
    dap.listeners.before.launch["save_all_buffers"] = function()
      vim.cmd("silent! wall")
    end
    dap.listeners.before.attach["save_all_buffers"] = function()
      vim.cmd("silent! wall")
    end
  end,
}
