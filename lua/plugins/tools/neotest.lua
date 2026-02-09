-- Neotest: Testing framework
-- Supports Go, Python, Rust

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
        -- Go adapter with experimental options for go.work support
        require("neotest-go")({
          experimental = {
            test_table = true,
          },
          -- Recursively discover tests in subdirectories
          recursive_run = true,
          -- Arguments to pass to `go test`
          args = { "-count=1" },
        }),
        require("neotest-python")({
          dap = { justMyCode = false },
          runner = "pytest",
        }),
        require("rustaceanvim.neotest"),
      },
      -- Status signs
      status = {
        virtual_text = true,
        signs = true,
      },
      -- Output settings
      output = {
        enabled = true,
        open_on_run = "short",
      },
      -- Discovery settings
      discovery = {
        enabled = true,
        concurrent = 1,
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
