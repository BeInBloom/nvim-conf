-- Rust Language Support
-- rust-analyzer + codelldb via rustaceanvim

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

          -- Organize imports + Format on save for Rust
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              -- Remove unused imports (like Go's goimports)
              local params = vim.lsp.util.make_range_params()
              params.context = { only = { "source.organizeImports" }, diagnostics = {} }
              local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 1000)
              for _, res in pairs(result or {}) do
                for _, r in pairs(res.result or {}) do
                  if r.edit then
                    vim.lsp.util.apply_workspace_edit(r.edit, client.offset_encoding)
                  end
                end
              end

              -- Format
              vim.lsp.buf.format({
                bufnr = bufnr,
                async = false,
                timeout_ms = 3000,
              })
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
            -- Use default rustfmt settings (like gofmt approach)
            rustfmt = {
              extraArgs = {},
            },
          },
        },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
    end,
  },

  -- Disable independent rust_analyzer (let rustaceanvim frame it)
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      handlers = {
        rust_analyzer = false, 
      },
      filetypes = {
        rust = false, -- let rustaceanvim handle filetype stuff if needed (usually fine to keep)
      },
    },
  },
  
  -- Mason Ensure Installed (redundant if using tools/mason.lua, but safe to keep for context)
  -- We already added 'codelldb' and 'rust_analyzer' to tools/mason.lua
}
