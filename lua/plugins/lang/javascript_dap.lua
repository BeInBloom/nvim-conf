local dap_utils = require "utils.dap"
local mason = require "utils.mason"

local languages = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

local function configurations()
  return {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch with arguments",
      program = "${file}",
      cwd = "${workspaceFolder}",
      args = function() return dap_utils.prompt_args() end,
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach",
      processId = require("dap.utils").pick_process,
      cwd = "${workspaceFolder}",
    },
  }
end

---@type LazySpec
return {
  "mfussenegger/nvim-dap",
  opts = function()
    local dap = require "dap"

    if not dap.adapters["pwa-node"] then
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = mason.bin "js-debug-adapter",
          args = { "${port}" },
        },
      }
    end

    for _, language in ipairs(languages) do
      if not dap.configurations[language] then dap.configurations[language] = configurations() end
    end
  end,
}
