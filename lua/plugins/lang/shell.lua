-- Shell Script Support (Bash, Sh, etc.)
-- bashls + shfmt + shellcheck

---@type LazySpec
return {
  -- LSP: Bash Language Server
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      servers = { "bashls" },
      config = {
        bashls = {
          filetypes = { "sh", "bash", "inc", "command", "pkgbuild" },
          settings = {
             bashIde = { globPattern = "**/*@(.sh|.inc|.bash|.command)" },
          },
        },
      },
    },
  },

  -- Formatting & Linting via none-ls
  {
      "nvimtools/none-ls.nvim",
      opts = function(_, opts)
        local null_ls = require "null-ls"
        opts.sources = require("astrocore").list_insert_unique(opts.sources, {
           -- Formatting
           null_ls.builtins.formatting.shfmt.with {
             -- Indent 2 spaces
             extra_args = { "-i", "2", "-s", "-ci" },
           },
           -- Linting
           require("none-ls.diagnostics.shellcheck").with {
              command = vim.fn.stdpath("data") .. "/mason/bin/shellcheck",
              condition = function()
                return vim.fn.executable(vim.fn.stdpath("data") .. "/mason/bin/shellcheck") == 1
              end,
           },
           require("none-ls.code_actions.shellcheck").with {
              command = vim.fn.stdpath("data") .. "/mason/bin/shellcheck",
              condition = function()
                return vim.fn.executable(vim.fn.stdpath("data") .. "/mason/bin/shellcheck") == 1
              end,
           },
        })
      end,
  },
}
