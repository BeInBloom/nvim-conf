-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

---@type LazySpec
return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    event = "User AstroFile",
    opts = {
      debug = false,
      show_help = "yes",
      model = "claude-sonnet-4",
      prompts = {
        Explain = "Объясни выделенный код",
        Review = "Проверь выделенный код",
        Tests = "Напиши тесты для выделенного кода",
        Refactor = "Отрефактори выделенный код",
        FixCode = "Исправь проблемы в выделенном коде",
        BetterNamings = "Предложи лучшие названия для переменных и функций",
        Documentation = "Напиши документацию для выделенного кода",
        SwaggerApiDocs = "Напиши документацию API в формате Swagger",
        SwaggerJSDocs = "Напиши JSDoc комментарии",
        Summarize = "Сделай краткое резюме выделенного текста",
        Spelling = "Исправь орфографию и грамматику",
        Wording = "Улучши формулировку",
        Concise = "Перепиши более кратко",
      },
      auto_follow_cursor = false,
      show_folds = true,
      auto_insert_mode = false,
      insert_at_end = false,
      clear_chat_on_new_prompt = false,
      context = "buffers",
      history_path = vim.fn.stdpath "data" .. "/copilotchat_history",
      callback = nil,
    },
    config = function(_, opts)
      local chat = require "CopilotChat"
      local select = require "CopilotChat.select"

      chat.setup(opts)

      -- Добавляем пользовательские команды
      vim.api.nvim_create_user_command(
        "CopilotChatVisual",
        function(args) chat.ask(args.args, { selection = select.visual }) end,
        { nargs = "*", range = true }
      )

      vim.api.nvim_create_user_command(
        "CopilotChatInline",
        function(args)
          chat.ask(args.args, {
            selection = select.visual,
            window = {
              layout = "float",
              title = "Copilot Chat",
            },
          })
        end,
        { nargs = "*", range = true }
      )

      vim.api.nvim_create_user_command(
        "CopilotChatBuffer",
        function(args) chat.ask(args.args, { selection = select.buffer }) end,
        { nargs = "*" }
      )
    end,
    keys = {
      -- Основные команды
      { "<leader>ac", "<cmd>CopilotChat<cr>", desc = "CopilotChat - Chat" },
      { "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
      { "<leader>at", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
      { "<leader>ar", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
      { "<leader>aR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor code" },
      { "<leader>an", "<cmd>CopilotChatBetterNamings<cr>", desc = "CopilotChat - Better Naming" },

      -- Чат с выделенным кодом
      { "<leader>ac", ":CopilotChatVisual ", mode = "x", desc = "CopilotChat - Open in vertical split" },
      { "<leader>ax", ":CopilotChatInline<cr>", mode = "x", desc = "CopilotChat - Inline chat" },

      -- Быстрые действия
      {
        "<leader>aq",
        function()
          local input = vim.fn.input "Quick Chat: "
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
          end
        end,
        desc = "CopilotChat - Quick chat",
      },

      -- Помощь с ошибками
      { "<leader>ad", "<cmd>CopilotChatFixDiagnostic<cr>", desc = "CopilotChat - Fix Diagnostic" },
      { "<leader>al", "<cmd>CopilotChatReset<cr>", desc = "CopilotChat - Clear buffer and chat history" },
    },
  },
}
