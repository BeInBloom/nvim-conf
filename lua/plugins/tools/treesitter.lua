-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua", "vim", "vimdoc",
      "go", "gomod", "gosum",
      "python",
      "rust",
      "javascript", "typescript", "tsx",
      "json", "yaml", "toml",
      "html", "css",
      "bash",
      "markdown", "markdown_inline",
      "dockerfile",
      "sql",
    },
  },
}
