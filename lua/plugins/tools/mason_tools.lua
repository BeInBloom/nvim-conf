---@type LazySpec
return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  opts = function(_, opts)
    opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed or {}, {
      "stylua",
      "golangci-lint",
      "gofumpt",
      "prettierd",
      "eslint_d",
      "shfmt",
      "shellcheck",
    })
  end,
}
