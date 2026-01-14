-- Rust Language Support
-- rust-analyzer + codelldb via rustaceanvim

---@type LazySpec
return {
  {
    "mrcjkb/rustaceanvim",
    version = "^5", -- Recommended
    ft = { "rust" },
    opts = {
      server = {
        on_attach = function(client, bufnr)
          -- AstroLSP bindings
          require("astrolsp").on_attach(client, bufnr)
        end,
        -- Share capabilities
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
              buildScripts = {
                enable = true,
              },
            },
            -- Clippy lints
            checkOnSave = {
              allFeatures = true,
              command = "clippy",
              extraArgs = { "--no-deps" },
            },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
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
