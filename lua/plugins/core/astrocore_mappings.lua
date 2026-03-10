---@type LazySpec
return {
  "AstroNvim/astrocore",
  opts = function(_, opts)
    local astrocore = require "astrocore"
    local maps = astrocore.empty_map_table()

    maps.n["H"] = { "<Cmd>bprevious<CR>", desc = "Previous buffer" }
    maps.n["L"] = { "<Cmd>bnext<CR>", desc = "Next buffer" }
    maps.n["<Leader>W"] = { "<Cmd>wall<CR>", desc = "Save all buffers" }
    maps.n["<Leader>bd"] = {
      function()
        require("astroui.status.heirline").buffer_picker(function(bufnr) require("astrocore.buffer").close(bufnr) end)
      end,
      desc = "Pick buffer to close",
    }

    opts.mappings = astrocore.extend_tbl(opts.mappings, maps)
  end,
}
