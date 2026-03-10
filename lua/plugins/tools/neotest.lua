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
  opts = function()
    return {
      adapters = {
        require "neotest-go" {
          experimental = {
            test_table = true,
          },
          recursive_run = true,
          args = { "-count=1" },
        },
        require "neotest-python" {
          dap = { justMyCode = false },
          runner = "pytest",
        },
        require "rustaceanvim.neotest",
      },
      status = {
        virtual_text = true,
        signs = true,
      },
      output = {
        enabled = true,
        open_on_run = "short",
      },
      discovery = {
        enabled = true,
        concurrent = 1,
      },
    }
  end,
  config = function(_, opts) require("neotest").setup(opts) end,
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
      "<Leader>Td",
      function() require("neotest").run.run(vim.fn.getcwd()) end,
      desc = "Run all tests in directory",
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
    {
      "<Leader>TD",
      function() require("neotest").run.run { strategy = "dap" } end,
      desc = "Debug nearest test",
    },
  },
}
