---@type LazySpec
return {
  "AstroNvim/astrolsp",
  opts = function(_, opts)
    return require("astrocore").extend_tbl(opts, {
      features = {
        codelens = true,
        inlay_hints = false,
        semantic_tokens = true,
      },
    })
  end,
}
