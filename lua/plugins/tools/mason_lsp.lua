---@type LazySpec
return {
  "williamboman/mason-lspconfig.nvim",
  opts = function(_, opts)
    opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed or {}, {
      "lua_ls",
      "ty",
      "ruff",
      "gopls",
      "vtsls",
      "svelte",
      "tailwindcss",
      "html",
      "cssls",
      "emmet_ls",
      "bashls",
    })
  end,
}
