local astrocore = require "astrocore"

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  opts = function(_, opts)
    opts.servers = astrocore.list_insert_unique(opts.servers or {}, { "bashls" })
    opts.config = opts.config or {}
    opts.config.bashls = astrocore.extend_tbl(opts.config.bashls or {}, {
      filetypes = { "sh", "bash", "inc", "command", "pkgbuild" },
      settings = {
        bashIde = {
          globPattern = "**/*@(.sh|.inc|.bash|.command)",
        },
      },
    })
  end,
}
