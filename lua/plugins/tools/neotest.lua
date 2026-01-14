return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-go",
    "nvim-neotest/neotest-python",
    -- rustaceanvim provides its own adapter, no need to install one
  },
  config = function()
    require("neotest").setup {
      adapters = {
        require "neotest-go",
        require "neotest-python",
        require "rustaceanvim.neotest",
      },
    }
  end,
  keys = {
    { "<Leader>T", desc = "Test" },
    {
      "<Leader>Tt",
      function() require("neotest").run.run() end,
      desc = "Run nearest test",
    },
    {
      "<Leader>Tf",
      function() require("neotest").run.run(vim.fn.expand "%") end,
      desc = "Run file",
    },
    {
      "<Leader>TS",
      function() require("neotest").run.stop() end,
      desc = "Stop test",
    },
    {
      "<Leader>Ts",
      function() require("neotest").summary.toggle() end,
      desc = "Toggle Summary",
    },
    {
      "<Leader>To",
      function() require("neotest").output.open { enter = true } end,
      desc = "Show Output",
    },
    {
      "<Leader>Tp",
      function() require("neotest").output_panel.toggle() end,
      desc = "Toggle Output Panel",
    },
  },
}
