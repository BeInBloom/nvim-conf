local rt = require "rust-tools"

return {
  -- расширение существующих настроек
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        loadOutDirsFromCheck = true,
        allFeatures = true,
        features = "all",
      },
      check = {
        command = "clippy",
        extraArgs = { "--all", "--message-format=json" },
      },
      procMacro = {
        enable = true,
      },
      rustfmt = {
        extraArgs = {}, -- или дополнительные флаги
      },
    },
  },
  on_attach = function(_, bufnr)
    -- Пример: назначить ключ для hover actions
    vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
    -- ещё keybindings (run, debug, expand macro и др.)
    vim.keymap.set("n", "<leader>rr", rt.runnables.runnables, { buffer = bufnr })
    vim.keymap.set("n", "<leader>rd", rt.debuggables.debuggables, { buffer = bufnr })
  end,
  tools = {
    hover_actions = {
      auto_focus = true,
    },
    inlay_hints = {
      auto = true,
      show_parameter_hints = true,
    },
  },
}
