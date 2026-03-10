local astrocore = require "astrocore"
local lsp = require "utils.lsp"
local root = require "utils.root"

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  opts = function(_, opts)
    opts.servers = astrocore.list_insert_unique(opts.servers or {}, { "phpactor" })
    opts.config = opts.config or {}
    opts.config.phpactor = astrocore.extend_tbl(opts.config.phpactor or {}, {
      filetypes = { "php", "blade" },
      root_dir = root.detector { "composer.json", ".git" },
      init_options = {
        ["code_transform.import_sort.strategy"] = "alpha",
        ["completion.insert_use_declaration"] = true,
        ["language_server_phpstan.enabled"] = true,
        ["language_server_psalm.enabled"] = false,
      },
      settings = {
        phpactor = {
          ["code_transform.import_sort.strategy"] = "alpha",
          ["completion.insert_use_declaration"] = true,
          ["inlay_hints.enable"] = true,
          ["inlay_hints.params"] = true,
          ["inlay_hints.types"] = true,
          ["language_server_phpstan.enabled"] = true,
          ["language_server_phpstan.level"] = 8,
        },
      },
      on_attach = function(client, bufnr)
        require("astrolsp").on_attach(client, bufnr)
        lsp.map_organize_imports(bufnr, "phpactor")
      end,
    })
    opts.autocmds = astrocore.extend_tbl(opts.autocmds or {}, {
      php_organize_imports = {
        cond = function(client) return client.name == "phpactor" end,
        {
          event = "BufWritePre",
          desc = "Organize imports (PHP)",
          callback = lsp.organize_imports_on_save("phpactor", 3000),
        },
      },
    })
  end,
}
