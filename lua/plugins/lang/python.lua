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
        -- Pyrefly: Type checker
        pyrefly = {
          cmd = { vim.fn.stdpath "data" .. "/mason/bin/pyrefly", "lsp" },
          filetypes = { "python" },
          root_dir = function(fname)
            return require("lspconfig").util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", ".git")(fname)
              or vim.fn.getcwd()
          end,
          single_file_support = true,
          capabilities = {
            offsetEncoding = { "utf-8" },
          },
          settings = {
            python = {
              pyrefly = {
                displayTypeErrors = "force-on",
              },
            },
          },
        },
        -- Ruff: Linter & Formatter
        ruff = {
          cmd = { "ruff", "server" },
          filetypes = { "python" },
          -- Force UTF-8 (align clients)
          capabilities = {
            offsetEncoding = { "utf-8" },
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
      autocmds = {
        python_organize_imports = {
          cond = function(client, _)
              return client.name == "ruff" and client.supports_method("textDocument/codeAction")
          end,
          {
            event = "BufWritePre",
            desc = "Organize Imports (Python)",
            callback = function(args)
               -- Use pcall to prevent saving from failing if Ruff errors out
               local status = pcall(function()
                  local clients = vim.lsp.get_clients({ bufnr = args.buf, name = "ruff" })
                  local client = clients[1]
                  if not client then return end
                  
                  local encoding = client.offset_encoding or "utf-8"
                  local params = vim.lsp.util.make_range_params(nil, encoding)
                  params.context = { only = { "source.organizeImports" }, diagnostics = {} }
                  
                  local result = vim.lsp.buf_request_sync(args.buf, "textDocument/codeAction", params, 1000)
                  for _, res in pairs(result or {}) do
                    for _, r in pairs(res.result or {}) do
                      if r.edit then
                        vim.lsp.util.apply_workspace_edit(r.edit, encoding)
                      end
                    end
                  end
               end)
               if not status then
                  -- Optional: print("Ruff organize imports failed")
               end
            end,
          },
        },
      },
    },
  },

  -- DAP (Debug Adapter Protocol)
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      -- Path to debugpy (Mason)
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
          name = "Launch (Args)",
          program = "${file}",
          args = function()
            local args_string = vim.fn.input "Arguments: "
            return vim.split(args_string, " +")
          end,
        },
        {
          type = "python",
          request = "launch",
          name = "Launch file (Ext Libs)", 
          program = "${file}",
          justMyCode = false, -- Step into libs
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
