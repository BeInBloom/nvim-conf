-- Customize Mason plugins to install tools
---@type LazySpec
return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "lua_ls",
        "pyrefly", 
        "ruff",
        "gopls",
        -- rust_analyzer managed by rustaceanvim
        "vtsls", -- TS/JS
        "html",
        "cssls",
        "emmet_ls", 
        "bashls",
        -- "fish_lsp", -- Skipped (stability)
      })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "python", -- debugpy
        "delve",  -- go
        "codelldb", -- rust
        "js", -- js-debug-adapter
      })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "stylua",
        "golangci-lint", 
        "gofumpt",
        "prettierd",
        "eslint_d",
        "shfmt",
        "shellcheck",
      })
    end,
  },
}
