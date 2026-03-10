---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    local null_ls = require "null-ls"

    opts.sources = require("astrocore").list_insert_unique(opts.sources or {}, {
      null_ls.builtins.diagnostics.golangci_lint.with {
        condition = function(utils)
          return utils.root_has_file {
            ".golangci.yml",
            ".golangci.yaml",
            ".golangci.toml",
            ".golangci.json",
          }
        end,
      },
    })
  end,
}
