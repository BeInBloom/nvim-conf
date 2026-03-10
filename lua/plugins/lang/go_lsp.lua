local astrocore = require "astrocore"
local lsp = require "utils.lsp"
local root = require "utils.root"

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  opts = function(_, opts)
    opts.servers = astrocore.list_insert_unique(opts.servers or {}, { "gopls" })
    opts.config = opts.config or {}
    opts.config.gopls = astrocore.extend_tbl(opts.config.gopls or {}, {
      cmd = { "gopls" },
      filetypes = { "go", "gomod", "gowork", "gotmpl" },
      root_dir = root.detector { "go.work", "go.mod", ".git" },
      settings = {
        gopls = {
          completeUnimported = true,
          usePlaceholders = true,
          gofumpt = true,
          analyses = {
            ST1000 = false,
            ST1003 = true,
            ST1020 = false,
            ST1021 = false,
            ST1022 = false,
            fieldalignment = false,
            fillreturns = true,
            nilness = true,
            nonewvars = true,
            shadow = true,
            undeclaredname = true,
            unreachable = true,
            unusedparams = true,
            unusedwrite = true,
            useany = true,
          },
          codelenses = {
            gc_details = false,
            generate = true,
            regenerate_cgo = true,
            run_govulncheck = true,
            test = true,
            tidy = true,
            upgrade_dependency = true,
            vendor = true,
          },
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
          diagnosticsDelay = "500ms",
          directoryFilters = { "-**/node_modules", "-**/.git", "-.idea", "-.vscode" },
          expandWorkspaceToModule = true,
          matcher = "Fuzzy",
          semanticTokens = true,
          staticcheck = true,
          symbolMatcher = "fuzzy",
        },
      },
    })
    opts.autocmds = astrocore.extend_tbl(opts.autocmds or {}, {
      go_organize_imports = {
        cond = function(client) return client.name == "gopls" end,
        {
          event = "BufWritePre",
          desc = "Organize imports (Go)",
          callback = lsp.organize_imports_on_save("gopls", 3000),
        },
      },
    })
  end,
}
