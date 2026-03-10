local dap_utils = require "utils.dap"
local mason = require "utils.mason"

---@type LazySpec
return {
  "mfussenegger/nvim-dap",
  opts = function()
    local dap = require "dap"

    if not dap.adapters.php then
      dap.adapters.php = {
        type = "executable",
        command = "node",
        args = { mason.package("php-debug-adapter", "extension", "out", "phpDebug.js") },
      }
    end

    dap.configurations.php = {
      {
        type = "php",
        request = "launch",
        name = "Listen for Xdebug",
        port = 9003,
        pathMappings = {
          ["/var/www/html"] = "${workspaceFolder}",
        },
      },
      {
        type = "php",
        request = "launch",
        name = "Launch script",
        script = "${file}",
        program = "${file}",
        cwd = "${workspaceFolder}",
        port = 9003,
      },
      {
        type = "php",
        request = "launch",
        name = "Launch with arguments",
        script = "${file}",
        program = "${file}",
        cwd = "${workspaceFolder}",
        port = 9003,
        args = function() return dap_utils.prompt_args() end,
      },
    }
  end,
}
