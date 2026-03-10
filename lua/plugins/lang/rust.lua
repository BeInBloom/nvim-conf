local lsp = require "utils.lsp"

---@type LazySpec
return {
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = { "rust" },
    opts = {
      server = {
        on_attach = function(client, bufnr)
          require("astrolsp").on_attach(client, bufnr)
          lsp.map_organize_imports(bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format {
                bufnr = bufnr,
                async = false,
                timeout_ms = 3000,
              }
            end,
          })
        end,
        capabilities = vim.tbl_deep_extend(
          "force",
          vim.lsp.protocol.make_client_capabilities(),
          require("astrolsp").capabilities or {}
        ),
        default_settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = { enable = true },
            },
            checkOnSave = true,
            check = {
              allFeatures = true,
              command = "clippy",
              extraArgs = { "--no-deps" },
            },
            procMacro = {
              enable = true,
            },
            rustfmt = {
              extraArgs = {},
            },
          },
        },
      },
    },
    config = function(_, opts) vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {}) end,
  },

  -- Disable independent rust_analyzer (let rustaceanvim frame it)
  {
    "AstroNvim/astrolsp",
    opts = {
      handlers = {
        rust_analyzer = false,
      },
    },
  },
}
