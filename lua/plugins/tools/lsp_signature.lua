-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

---@type LazySpec
return {
  "ray-x/lsp_signature.nvim",
  event = "LspAttach",
  opts = {
    hint_enable = false,
    handler_opts = { border = "rounded" },
    floating_window = true,
    always_trigger = true,
    toggle_key = "<M-s>",
  },
}
