---@type LazySpec
return {
  "AstroNvim/astrocore",
  opts = function(_, opts)
    return require("astrocore").extend_tbl(opts, {
      features = {
        large_buf = { size = 1024 * 256, lines = 10000 },
        autopairs = true,
        cmp = true,
        diagnostics = true,
        highlighturl = true,
        notifications = true,
      },
      diagnostics = {
        virtual_text = true,
        virtual_lines = false,
        underline = true,
      },
    })
  end,
}
