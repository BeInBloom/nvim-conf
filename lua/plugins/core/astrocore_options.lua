---@type LazySpec
return {
  "AstroNvim/astrocore",
  opts = function(_, opts)
    opts.options = require("astrocore").extend_tbl(opts.options, {
      opt = {
        autoindent = true,
        number = true,
        relativenumber = true,
        scrolloff = 15,
        signcolumn = "yes",
        spell = false,
        wrap = false,
      },
    })
  end,
}
