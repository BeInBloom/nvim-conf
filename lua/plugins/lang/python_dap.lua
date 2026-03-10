local mason = require "utils.mason"
local dap_utils = require "utils.dap"

---@type LazySpec
return {
  "mfussenegger/nvim-dap-python",
  ft = "python",
  dependencies = { "mfussenegger/nvim-dap" },
  config = function()
    require("dap-python").setup(mason.package("debugpy", "venv", "bin", "python"))

    local dap = require "dap"
    dap.configurations.python = {
      {
        type = "python",
        request = "launch",
        name = "Launch file",
        program = "${file}",
      },
      {
        type = "python",
        request = "launch",
        name = "Launch with arguments",
        program = "${file}",
        args = function() return dap_utils.prompt_args() end,
      },
      {
        type = "python",
        request = "launch",
        name = "Launch file (Ext libs)",
        program = "${file}",
        justMyCode = false,
      },
      {
        type = "python",
        request = "attach",
        name = "Attach remote",
        connect = function()
          local host = vim.fn.input "Host [127.0.0.1]: "
          local port = tonumber(vim.fn.input "Port [5678]: ") or 5678
          return {
            host = host ~= "" and host or "127.0.0.1",
            port = port,
          }
        end,
      },
    }
  end,
}
