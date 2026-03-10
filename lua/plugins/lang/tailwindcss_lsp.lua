local astrocore = require "astrocore"

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  opts = function(_, opts)
    opts.servers = astrocore.list_insert_unique(opts.servers or {}, { "tailwindcss" })
    opts.config = opts.config or {}
    opts.config.tailwindcss = astrocore.extend_tbl(opts.config.tailwindcss or {}, {
      settings = {
        tailwindCSS = {
          validate = true,
          classAttributes = {
            "class",
            "className",
            "class:list",
            "classList",
            "ngClass",
          },
          includeLanguages = {
            eelixir = "html-eex",
            eruby = "erb",
            templ = "html",
            htmlangular = "html",
          },
          lint = {
            cssConflict = "warning",
            invalidApply = "error",
            invalidConfigPath = "error",
            invalidScreen = "error",
            invalidTailwindDirective = "error",
            invalidVariant = "error",
            recommendedVariantOrder = "warning",
          },
        },
      },
      on_new_config = function(new_config)
        new_config.settings = new_config.settings or {}
        new_config.settings.editor = new_config.settings.editor or {}
        new_config.settings.editor.tabSize = new_config.settings.editor.tabSize
          or vim.lsp.util.get_effective_tabstop()
      end,
    })
  end,
}
