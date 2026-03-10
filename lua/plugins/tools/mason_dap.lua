---@type LazySpec
return {
  "jay-babu/mason-nvim-dap.nvim",
  opts = function(_, opts)
    opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed or {}, {
      "python",
      "delve",
      "codelldb",
      "js",
    })
  end,
}
