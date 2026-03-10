local mason = require "utils.mason"

---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  dependencies = { "gbprod/none-ls-shellcheck.nvim" },
  opts = function(_, opts)
    local null_ls = require "null-ls"
    local shellcheck = mason.bin "shellcheck"

    opts.sources = require("astrocore").list_insert_unique(opts.sources or {}, {
      null_ls.builtins.formatting.shfmt.with {
        extra_args = { "-i", "2", "-s", "-ci" },
      },
      require("none-ls-shellcheck.code_actions").with {
        command = shellcheck,
        condition = function() return vim.fn.executable(shellcheck) == 1 end,
      },
      require("none-ls-shellcheck.diagnostics").with {
        command = shellcheck,
        condition = function() return vim.fn.executable(shellcheck) == 1 end,
      },
    })
  end,
}
