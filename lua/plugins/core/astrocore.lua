-- AstroCore: Central configuration for mappings, options, and autocommands
-- See :h astrocore for docs

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- limit for large files (disables heavy features)
      autopairs = true, 
      cmp = true,
      diagnostics = { virtual_text = true, virtual_lines = false },
      highlighturl = true,
      notifications = true,
    },
    -- Configure formatting options
    formatting = {
      format_on_save = {
        enabled = true, -- enable or disable format on save globally
      },
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- passed to `vim.filetype.add`

    filetypes = { extension = {}, filename = {}, pattern = {} },

    -- vim options (vim.opt.<key>)
    options = {
      opt = {
        relativenumber = true,
        number = true,
        spell = false,
        signcolumn = "yes",
        wrap = false,
        scrolloff = 15,
      },
      g = {
        -- vim.g.<key>
        -- NOTE: mapleader/localleader in lazy_setup.lua
      },
    },

    -- Mappings (n: normal mode, etc.)
    mappings = {
      n = {
        -- Buffer navigation
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- Close buffer
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- LSP CodeLens
        ["<Leader>lG"] = { function() vim.lsp.codelens.run() end, desc = "LSP CodeLens Run" },

        -- Save all buffers
        ["<Leader>W"] = { "<cmd>wall<cr>", desc = "Save all buffers" },
      },
    },
  },

}
