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
          -- Inject AstroLSP keybindings and logic
          require("astrolsp").on_attach(client, bufnr)
        end,
        -- Ensure capabilities are shared
        capabilities = vim.tbl_deep_extend(
          "force",
          vim.lsp.protocol.make_client_capabilities(),
          require("astrolsp").capabilities or {}
        ),
        default_settings = {
          -- rust-analyzer language server configuration
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            -- Add clippy lints for Rust
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

  -- Ensure we don't duplicate rust_analyzer setup in astrolsp if using rustaceanvim
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      handlers = {
        -- set rust_analyzer handler to false to let rustaceanvim handle it
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
