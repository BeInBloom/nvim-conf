-- HTML & CSS Support
-- html + cssls + emmet_ls + (prettier already via Mason)

---@type LazySpec
return {
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      servers = {
        "html",
        "cssls",
        "emmet_ls",
      },
      config = {
        html = {
           init_options = {
              provideFormatter = false, -- Use prettier
           },
        },
        cssls = {
           init_options = {
              provideFormatter = false, -- Use prettier
           },
           settings = {
              css = { validate = true, lint = { unknownAtRules = "ignore" } },
              scss = { validate = true, lint = { unknownAtRules = "ignore" } },
              less = { validate = true, lint = { unknownAtRules = "ignore" } },
           },
        },
        emmet_ls = {
           filetypes = { 
              "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "eruby"
           },
           init_options = {
             html = {
               options = {
                 -- specific options for emmet if needed
               },
             },
           },
        },
      },
      -- Formatting is handled by none-ls (prettierd) configuration globally or in explicit configs.
      -- Since prettierd is set up in `tools/none-ls.lua` or `javascript.lua` (we should check generic availability),
      -- we rely on it.
    },
  },
  
  -- Ensure prettier handles html/css via none-ls
  {
      "nvimtools/none-ls.nvim",
      opts = function(_, opts)
        local null_ls = require "null-ls"
        opts.sources = require("astrocore").list_insert_unique(opts.sources, {
           -- Prettierd is usually capable of all, but explicit add here is safe
           null_ls.builtins.formatting.prettierd, 
        })
      end,
  },
}
