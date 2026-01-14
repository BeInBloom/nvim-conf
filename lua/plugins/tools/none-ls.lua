-- None-ls Configuration (Base)
-- Language-specific sources are in lang/*.lua

---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  dependencies = { "nvimtools/none-ls-extras.nvim" },
  opts = function(_, opts)
    -- Base configuration for none-ls
    -- Language-specific sources are added in lang/*.lua files
    opts.sources = opts.sources or {}
  end,
}
