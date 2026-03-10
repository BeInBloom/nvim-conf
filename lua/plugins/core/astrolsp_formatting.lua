---@type LazySpec
return {
  "AstroNvim/astrolsp",
  opts = function(_, opts)
    return require("astrocore").extend_tbl(opts, {
      formatting = {
        format_on_save = {
          enabled = true,
          allow_filetypes = {
            "lua",
            "python",
            "go",
            "gomod",
            "rust",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "svelte",
            "html",
            "css",
            "scss",
            "less",
            "json",
            "yaml",
            "toml",
            "sh",
            "bash",
            "markdown",
            "dockerfile",
          },
          ignore_filetypes = {},
        },
        disabled = {},
        timeout_ms = 2000,
      },
    })
  end,
}
