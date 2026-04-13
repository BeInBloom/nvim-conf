---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  main = "nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  init = function(plugin)
    require("lazy.core.loader").add_to_rtp(plugin)
    pcall(require, "nvim-treesitter.query_predicates")
  end,
  opts = {
    install_dir = vim.fn.stdpath "data" .. "/site",
    parser_install_dir = vim.fn.stdpath "data" .. "/site",
    ensure_installed = {
      "bash",
      "blade",
      "css",
      "dockerfile",
      "go",
      "gomod",
      "gosum",
      "gowork",
      "html",
      "javascript",
      "json",
      "lua",
      "markdown",
      "markdown_inline",
      "php",
      "phpdoc",
      "python",
      "query",
      "rust",
      "sql",
      "svelte",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
    },
    highlight = { enable = true },
    incremental_selection = { enable = true },
    indent = { enable = true },
  },
  config = function(_, opts)
    local ok_ts, ts = pcall(require, "nvim-treesitter")
    if ok_ts and ts.setup then
      ts.setup { install_dir = opts.install_dir }
    end

    local ok_cfg, configs = pcall(require, "nvim-treesitter.configs")
    if ok_cfg and configs.setup then
      configs.setup {
        parser_install_dir = opts.parser_install_dir,
        ensure_installed = opts.ensure_installed,
        highlight = opts.highlight,
        incremental_selection = opts.incremental_selection,
        indent = opts.indent,
      }
    end

    vim.api.nvim_create_autocmd("FileType", {
      desc = "Enable treesitter highlighting",
      callback = function(args)
        if opts.highlight and opts.highlight.enable ~= false then
          pcall(vim.treesitter.start, args.buf)
        end

        pcall(function()
          vim.wo[vim.api.nvim_get_current_win()].foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.wo[vim.api.nvim_get_current_win()].foldmethod = "expr"
        end)
      end,
    })
  end,
}
