---@type LazySpec
return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    event = "User AstroFile",
    dependencies = {
      "zbirenbaum/copilot.lua",
      "nvim-lua/plenary.nvim",
    },
    opts = {
      auto_follow_cursor = false,
      auto_insert_mode = false,
      clear_chat_on_new_prompt = false,
      context = "buffers",
      debug = false,
      history_path = vim.fn.stdpath "data" .. "/copilotchat_history",
      insert_at_end = false,
      model = "claude-sonnet-4",
      show_folds = true,
      show_help = "yes",
      prompts = {
        BetterNamings = "Предложи лучшие названия для переменных и функций",
        Concise = "Перепиши более кратко",
        Documentation = "Напиши документацию для выделенного кода",
        Explain = "Объясни выделенный код",
        FixCode = "Исправь проблемы в выделенном коде",
        Refactor = "Отрефактори выделенный код",
        Review = "Проверь выделенный код",
        Spelling = "Исправь орфографию и грамматику",
        Summarize = "Сделай краткое резюме выделенного текста",
        SwaggerApiDocs = "Напиши документацию API в формате Swagger",
        SwaggerJSDocs = "Напиши JSDoc комментарии",
        Tests = "Напиши тесты для выделенного кода",
        Wording = "Улучши формулировку",
      },
    },
    config = function(_, opts)
      local chat = require "CopilotChat"
      local select = require "CopilotChat.select"

      local function command(name, selection, extra)
        vim.api.nvim_create_user_command(
          name,
          function(args) chat.ask(args.args, vim.tbl_extend("force", { selection = selection }, extra or {})) end,
          { nargs = "*", range = selection == select.visual }
        )
      end

      chat.setup(opts)
      command("CopilotChatVisual", select.visual)
      command("CopilotChatBuffer", select.buffer)
      command("CopilotChatInline", select.visual, {
        window = {
          layout = "float",
          title = "Copilot Chat",
        },
      })
    end,
    keys = {
      { "<leader>ac", "<cmd>CopilotChat<cr>", desc = "Copilot Chat" },
      { "<leader>ad", "<cmd>CopilotChatFixDiagnostic<cr>", desc = "Fix diagnostic" },
      { "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "Explain code" },
      { "<leader>al", "<cmd>CopilotChatReset<cr>", desc = "Reset chat" },
      { "<leader>an", "<cmd>CopilotChatBetterNamings<cr>", desc = "Better naming" },
      {
        "<leader>aq",
        function()
          local input = vim.fn.input "Quick Chat: "
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
          end
        end,
        desc = "Quick chat",
      },
      { "<leader>ar", "<cmd>CopilotChatReview<cr>", desc = "Review code" },
      { "<leader>aR", "<cmd>CopilotChatRefactor<cr>", desc = "Refactor code" },
      { "<leader>at", "<cmd>CopilotChatTests<cr>", desc = "Generate tests" },
      { "<leader>ac", ":CopilotChatVisual ", mode = "x", desc = "Chat on selection" },
      { "<leader>ax", ":CopilotChatInline<cr>", mode = "x", desc = "Inline chat" },
    },
  },
}
