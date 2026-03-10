local astrocore = require "astrocore"
local lsp = require "utils.lsp"

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  opts = function(_, opts)
    opts.servers = astrocore.list_insert_unique(opts.servers or {}, { "vtsls" })
    opts.config = opts.config or {}
    opts.config.vtsls = astrocore.extend_tbl(opts.config.vtsls or {}, {
      on_attach = function(client) lsp.disable_formatting(client) end,
      settings = {
        vtsls = {
          autoUseWorkspaceTsdk = true,
          experimental = {
            completion = {
              enableServerSideFuzzyMatch = true,
            },
          },
        },
        typescript = {
          updateImportsOnFileMove = { enabled = "always" },
          inlayHints = {
            enumMemberValues = { enabled = true },
            functionLikeReturnTypes = { enabled = false },
            parameterNames = { enabled = "literals" },
            parameterTypes = { enabled = true },
            propertyDeclarationTypes = { enabled = true },
            variableTypes = { enabled = false },
          },
        },
        javascript = {
          updateImportsOnFileMove = { enabled = "always" },
          inlayHints = {
            enumMemberValues = { enabled = true },
            functionLikeReturnTypes = { enabled = false },
            parameterNames = { enabled = "literals" },
            parameterTypes = { enabled = true },
            propertyDeclarationTypes = { enabled = true },
            variableTypes = { enabled = false },
          },
        },
      },
    })
  end,
}
