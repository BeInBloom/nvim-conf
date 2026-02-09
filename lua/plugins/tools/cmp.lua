-- CMP (Completion) Configuration
-- Minimal overrides - let AstroNvim handle defaults

---@type LazySpec
return {
  "hrsh7th/nvim-cmp",
  opts = function(_, opts)
    local cmp = require "cmp"

    -- Override mapping to trigger completion on "."
    opts.mapping = vim.tbl_deep_extend("force", opts.mapping or {}, {
      -- Auto-trigger completion after "."
      ["."] = cmp.mapping(function(fallback)
        fallback() -- Insert the "."
        vim.defer_fn(function()
          cmp.complete()
        end, 50) -- Small delay to let LSP process
      end, { "i" }),
    })

    return opts
  end,
}
