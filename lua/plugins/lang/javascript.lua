-- JavaScript/TypeScript Support
-- vtsls + eslint_d + prettierd + js-debug-adapter

---@type LazySpec
return {
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      servers = { "vtsls" },
      config = {
        vtsls = {
          on_attach = function(client)
             -- Formatting handled by Prettier
             client.server_capabilities.documentFormattingProvider = false
             client.server_capabilities.documentRangeFormattingProvider = false
          end,
          -- https://github.com/yioneko/vtsls/blob/main/packages/service/configuration.schema.json
          settings = {
             vtsls = {
                autoUseWorkspaceTsdk = true,
                experimental = {
                   completion = {
                      enableServerSideFuzzyMatch = true,
                   },
                },
             },
             typescript = {
                updateImportsOnFileMove = { enabled = "always" },
                inlayHints = {
                   parameterNames = { enabled = "literals" },
                   parameterTypes = { enabled = true },
                   variableTypes = { enabled = false },
                   propertyDeclarationTypes = { enabled = true },
                   functionLikeReturnTypes = { enabled = false },
                   enumMemberValues = { enabled = true },
                },
             },
             javascript = {
                updateImportsOnFileMove = { enabled = "always" },
                inlayHints = {
                   parameterNames = { enabled = "literals" },
                   parameterTypes = { enabled = true },
                   variableTypes = { enabled = false },
                   propertyDeclarationTypes = { enabled = true },
                   functionLikeReturnTypes = { enabled = false },
                   enumMemberValues = { enabled = true },
                },
             },
          },
        },
      },
      formatting = {
         -- Control formatting here
         format_on_save = {
            allow_filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
         },
      },
    },
  },

  -- Prettier and ESLint via none-ls
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local null_ls = require "null-ls"
      local has_eslint_config = function(utils)
        return utils.root_has_file { 
          ".eslintrc", 
          ".eslintrc.js", 
          ".eslintrc.json", 
          ".eslintrc.yaml", 
          ".eslintrc.yml", 
          "eslint.config.js",
          "package.json" -- simplistic check, maybe too broad, but eslint is usually there
        }
      end

      opts.sources = require("astrocore").list_insert_unique(opts.sources, {
        null_ls.builtins.formatting.prettierd,
        require("none-ls.diagnostics.eslint_d").with {
           condition = has_eslint_config,
        },
        require("none-ls.code_actions.eslint_d").with {
           condition = has_eslint_config,
        },
      })
    end,
  },

  -- DAP: JS Debugger (Manual setup for pwa-node)
  {
    "mfussenegger/nvim-dap",
    opts = function()
       local dap = require("dap")
       if not dap.adapters["pwa-node"] then
          dap.adapters["pwa-node"] = {
             type = "server",
             host = "localhost",
             port = "${port}",
             executable = {
                command = vim.fn.stdpath "data" .. "/mason/bin/js-debug-adapter",
                args = { "${port}" },
             },
          }
       end
       
       for _, language in ipairs { "typescript", "javascript", "typescriptreact", "javascriptreact" } do
          if not dap.configurations[language] then
             dap.configurations[language] = {
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
                   name = "Launch with Arguments",
                   program = "${file}",
                   cwd = "${workspaceFolder}",
                   args = function()
                      local args_string = vim.fn.input "Arguments: "
                      return vim.split(args_string, " +")
                   end,
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
       end
    end,
  }
}
