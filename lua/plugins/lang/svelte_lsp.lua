local astrocore = require "astrocore"
local root = require "utils.root"

local function svelte_plugin_path()
  return vim.fs.joinpath(
    vim.fn.stdpath "data",
    "mason",
    "packages",
    "svelte-language-server",
    "node_modules",
    "typescript-svelte-plugin"
  )
end

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  opts = function(_, opts)
    opts.servers = astrocore.list_insert_unique(opts.servers or {}, { "svelte" })
    opts.config = opts.config or {}

    opts.config.vtsls = astrocore.extend_tbl(opts.config.vtsls or {}, {
      settings = {
        vtsls = {
          tsserver = {
            globalPlugins = {
              {
                name = "typescript-svelte-plugin",
                location = svelte_plugin_path(),
                configNamespace = "typescript",
                enableForWorkspaceTypeScriptVersions = true,
              },
            },
          },
        },
      },
    })

    opts.config.svelte = astrocore.extend_tbl(opts.config.svelte or {}, {
      root_dir = root.detector { "package.json", ".git" },
      settings = {
        typescript = {
          updateImportsOnFileMove = { enabled = "always" },
          inlayHints = {
            parameterNames = { enabled = "all" },
            parameterTypes = { enabled = true },
            variableTypes = { enabled = true },
            propertyDeclarationTypes = { enabled = true },
            functionLikeReturnTypes = { enabled = true },
            enumMemberValues = { enabled = true },
          },
        },
        javascript = {
          updateImportsOnFileMove = { enabled = "always" },
          inlayHints = {
            parameterNames = { enabled = "literals" },
            parameterTypes = { enabled = true },
            variableTypes = { enabled = true },
            propertyDeclarationTypes = { enabled = true },
            functionLikeReturnTypes = { enabled = true },
            enumMemberValues = { enabled = true },
          },
        },
      },
    })
  end,
}
