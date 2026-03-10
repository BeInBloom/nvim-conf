local astrocore = require "astrocore"

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  opts = function(_, opts)
    opts.servers = astrocore.list_insert_unique(opts.servers or {}, {
      "html",
      "cssls",
      "emmet_ls",
    })
    opts.config = opts.config or {}
    opts.config.html = astrocore.extend_tbl(opts.config.html or {}, {
      init_options = { provideFormatter = false },
    })
    opts.config.cssls = astrocore.extend_tbl(opts.config.cssls or {}, {
      init_options = { provideFormatter = false },
      settings = {
        css = { validate = true, lint = { unknownAtRules = "ignore" } },
        less = { validate = true, lint = { unknownAtRules = "ignore" } },
        scss = { validate = true, lint = { unknownAtRules = "ignore" } },
      },
    })
    opts.config.emmet_ls = astrocore.extend_tbl(opts.config.emmet_ls or {}, {
      filetypes = {
        "html",
        "typescriptreact",
        "javascriptreact",
        "css",
        "sass",
        "scss",
        "less",
        "eruby",
        "svelte",
      },
    })
  end,
}
