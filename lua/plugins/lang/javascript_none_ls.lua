local eslint_config_files = {
  ".eslintrc",
  ".eslintrc.js",
  ".eslintrc.cjs",
  ".eslintrc.json",
  ".eslintrc.yaml",
  ".eslintrc.yml",
  "eslint.config.js",
  "eslint.config.cjs",
  "eslint.config.mjs",
  "eslint.config.ts",
}

---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    opts.sources = require("astrocore").list_insert_unique(opts.sources or {}, {
      require("none-ls.code_actions.eslint_d").with {
        condition = function(utils) return utils.root_has_file(eslint_config_files) end,
      },
      require("none-ls.diagnostics.eslint_d").with {
        condition = function(utils) return utils.root_has_file(eslint_config_files) end,
      },
    })
  end,
}
