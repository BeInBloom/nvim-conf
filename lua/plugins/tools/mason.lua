-- Customize Mason plugins to install tools
---@type LazySpec
return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "lua_ls",
        -- "pyrefly", -- Installed manually via python.lua logic if needed, or here. 
        -- logic in python.lua uses absolute path, so it expects it to be there. 
        -- Let's ensure them here for safety.
        "pyrefly", 
        "ruff",
        "gopls",
        "rust_analyzer",
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
        -- "black", "isort" -- we use ruff now
      })
    end,
  },
}
