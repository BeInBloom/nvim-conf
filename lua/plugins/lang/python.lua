-- Python Language Support
-- pyrefly (type checker from Meta) + ruff (linter & formatter) + debugpy

---@type LazySpec
return {
  -- LSP Configuration for Python
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      servers = {
        "pyrefly",
        "ruff",
      },
      config = {
        -- Pyrefly: Type checker from Meta
        pyrefly = {
          cmd = { vim.fn.stdpath "data" .. "/mason/bin/pyrefly", "lsp" },
          filetypes = { "python" },
          root_dir = function(fname)
            return require("lspconfig").util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", ".git")(fname)
              or vim.fn.getcwd()
          end,
          single_file_support = true,
          settings = {
            python = {
              pyrefly = {
                displayTypeErrors = "force-on", -- Force enable type errors
              },
            },
          },
        },
        -- Ruff: Fast linter & formatter
        ruff = {
          cmd = { "ruff", "server" },
          filetypes = { "python" },
          -- Force UTF-16 to match Pyrefly (which defaults to UTF-16)
          capabilities = {
            offsetEncoding = { "utf-16" },
          },
          root_dir = require("lspconfig").util.root_pattern("pyproject.toml", "ruff.toml", ".ruff.toml", ".git"),
          settings = {
            ruff = {
              lint = { enable = true },
              format = { enable = true },
            },
          },
        },
      },
    },
  },

  -- DAP (Debug Adapter Protocol) for Python
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      -- Path to debugpy installed via Mason
      local mason_path = vim.fn.stdpath "data" .. "/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(mason_path)

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
          args = function()
            local args_string = vim.fn.input "Arguments: "
            return vim.split(args_string, " +")
          end,
        },
        {
          type = "python",
          request = "launch",
          name = "Launch file (External Libs)", 
          program = "${file}",
          justMyCode = false, -- Allow stepping into libraries
        },
        {
          type = "python",
          request = "attach",
          name = "Attach remote",
          connect = function()
            local host = vim.fn.input "Host [127.0.0.1]: "
            host = host ~= "" and host or "127.0.0.1"
            local port = tonumber(vim.fn.input "Port [5678]: ") or 5678
            return { host = host, port = port }
          end,
        },
      }
    end,
  },
}
