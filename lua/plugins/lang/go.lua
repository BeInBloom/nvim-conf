-- Go Language Support
-- gopls + golangci-lint + nvim-dap-go

---@type LazySpec
return {
  -- LSP Configuration for Go
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      config = {
        gopls = {
          cmd = { "gopls" },
          filetypes = { "go", "gomod", "gowork", "gotmpl" },
          root_dir = require("lspconfig").util.root_pattern("go.work", "go.mod", ".git"),
          settings = {
            gopls = {
              gofumpt = true, -- A stricter gofmt
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                unusedparams = true,
                shadow = true, -- Check for shadowed variables
                nilness = true,
                unusedwrite = true,
                useany = true,
                ST1000 = false, -- Incorrect or missing package comment
                ST1020 = false, -- Missing function doc comment
                ST1021 = false, -- Missing type doc comment
                ST1022 = false, -- Missing variable doc comment
              },
              staticcheck = true,
              semanticTokens = true, -- Experimental: semantic highlighting
            },
          },
        },
      },
      -- Formatting: Organize imports on save
      formatting = {
        format_on_save = {
          allow_filetypes = { "go" },
        },
      },
      autocmds = {
        go_organize_imports = {
          cond = function(client, _) return client.name == "gopls" end,
          {
            event = "BufWritePre",
            desc = "Organize Imports (Go)",
            callback = function(args)
               local clients = vim.lsp.get_clients({ bufnr = args.buf, name = "gopls" })
               local client = clients[1]
               if not client then return end

               local encoding = client.offset_encoding or "utf-8"
               local params = vim.lsp.util.make_range_params(nil, encoding)
               params.context = { only = { "source.organizeImports" } }
               
               local result = vim.lsp.buf_request_sync(args.buf, "textDocument/codeAction", params, 3000)
               for _, res in pairs(result or {}) do
                 for _, r in pairs(res.result or {}) do
                   if r.edit then
                     vim.lsp.util.apply_workspace_edit(r.edit, encoding)
                   end
                 end
               end
            end,
          },
        },
      },
    },
  },

  -- DAP: Go Debugger
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = {
      "mfussenegger/nvim-dap",
      {
        "jay-babu/mason-nvim-dap.nvim",
        opts = { handlers = { delve = function() end } }, -- Ensure mason doesn't override
      },
    },
    opts = {
      -- Explicitly configure delve path
      delve = {
        path = vim.fn.stdpath "data" .. "/mason/bin/dlv",
        initialize_configurations = true,
        show_stop_reason = true,
      },
      filetypes = { "go", "gomod" },
    },
    config = function(_, opts)
      require("dap-go").setup(opts)
      
      -- Manually define configurations to keep menu clean
      local dap = require "dap"
      dap.configurations.go = {
        {
          type = "go",
          name = "Debug",
          request = "launch",
          program = "${file}",
        },
        {
          type = "go",
          name = "Debug (Arguments)",
          request = "launch",
          program = "${file}",
          args = function()
             local args_string = vim.fn.input "Arguments: "
             return vim.split(args_string, " +")
          end,
        },
        {
          type = "go",
          name = "Debug (Build Flags)",
          request = "launch",
          program = "${file}",
          buildFlags = function()
            return vim.fn.input "Build Flags: " -- e.g. "-tags=integration"
          end,
        },
        {
          type = "go",
          name = "Debug test",
          request = "launch",
          mode = "test",
          program = "${file}",
        },
        {
          type = "go",
          name = "Attach",
          mode = "local",
          request = "attach",
          processId = require("dap.utils").pick_process,
        },
      }
    end,
  },

  -- Golangci-lint via none-ls
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local null_ls = require "null-ls"
      opts.sources = require("astrocore").list_insert_unique(opts.sources, {
        null_ls.builtins.diagnostics.golangci_lint.with {
          condition = function(utils) return utils.root_has_file ".golangci.yml" end,
        },
        -- We can optionally add formatting.gofumpt here if LSP one isn't enough, but gopls usually handles it.
        -- null_ls.builtins.formatting.gofumpt,
        -- null_ls.builtins.formatting.goimports,
        -- null_ls.builtins.formatting.golines,
      })
    end,
  },
}
