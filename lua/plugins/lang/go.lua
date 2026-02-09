-- Go Language Support
-- gopls + golangci-lint + nvim-dap-go

---@type LazySpec
return {
  -- LSP Configuration for Go (based on astrocommunity/pack/go)
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      ---@diagnostic disable-next-line: missing-fields
      config = {
        gopls = {
          cmd = { "gopls" },
          filetypes = { "go", "gomod", "gowork", "gotmpl" },
          root_dir = require("lspconfig").util.root_pattern("go.work", "go.mod", ".git"),
          settings = {
            gopls = {
              -- CRITICAL: Enable completion for unimported packages
              completeUnimported = true,
              usePlaceholders = true,
              
              -- Formatting
              gofumpt = true,
              
              -- Analyses
              analyses = {
                fieldalignment = false,
                fillreturns = true,
                nilness = true,
                nonewvars = true,
                shadow = true,
                undeclaredname = true,
                unreachable = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
                ST1000 = false, -- Pkg comment
                ST1003 = true,
                ST1020 = false, -- Func doc
                ST1021 = false, -- Type doc
                ST1022 = false, -- Var doc
              },
              
              -- Codelenses
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
              
              -- Inlay hints
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              
              -- Other settings
              diagnosticsDelay = "500ms",
              matcher = "Fuzzy",
              symbolMatcher = "fuzzy",
              semanticTokens = true,
              staticcheck = true,
            },
          },
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
               local params = {
                 textDocument = vim.lsp.util.make_text_document_params(args.buf),
                 range = {
                   start = { line = 0, character = 0 },
                   ["end"] = { line = vim.api.nvim_buf_line_count(args.buf), character = 0 },
                 },
                 context = { only = { "source.organizeImports" } },
               }

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

  -- Treesitter for Go
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed =
          require("astrocore").list_insert_unique(opts.ensure_installed, { "go", "gomod", "gosum", "gowork" })
      end
    end,
  },

  -- DAP: Go Debugger
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = {
      "mfussenegger/nvim-dap",
      {
        "jay-babu/mason-nvim-dap.nvim",
        opts = function(_, opts)
          opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "delve" })
        end,
      },
    },
    opts = {},
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
      })
    end,
  },
}
