local astrocore = require "astrocore"
local lsp = require "utils.lsp"
local root = require "utils.root"

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  opts = function(_, opts)
    opts.servers = astrocore.list_insert_unique(opts.servers or {}, {
      "ty",
      "ruff",
    })
    opts.config = opts.config or {}
    opts.config.ty = astrocore.extend_tbl(opts.config.ty or {}, {
      cmd = { "ty", "server" },
      filetypes = { "python" },
      root_dir = root.detector { "pyproject.toml", "setup.py", "setup.cfg", ".git" },
      single_file_support = true,
    })
    opts.config.ruff = astrocore.extend_tbl(opts.config.ruff or {}, {
      cmd = { "ruff", "server" },
      filetypes = { "python" },
      root_dir = root.detector { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
      settings = {
        ruff = {
          lint = { enable = true },
          format = { enable = true },
        },
      },
    })
    opts.autocmds = astrocore.extend_tbl(opts.autocmds or {}, {
      python_organize_imports = {
        cond = function(client) return client.name == "ruff" and client:supports_method "textDocument/codeAction" end,
        {
          event = "BufWritePre",
          desc = "Organize imports (Python)",
          callback = lsp.organize_imports_on_save("ruff", 1000),
        },
      },
    })
  end,
}
