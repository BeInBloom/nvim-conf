return {
  -- Valid database UI
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },

  -- Add CMP source for dadbod
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      -- Add "vim-dadbod-completion" source
      local cmp = require "cmp"
      opts.sources = cmp.config.sources(
        require("astrocore").list_insert_unique(opts.sources, { 
          { name = "vim-dadbod-completion" } 
        })
      )
    end,
  },
}
