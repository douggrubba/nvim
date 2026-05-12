local function set_chat_source()
  local ok, chat = pcall(require, "CopilotChat")
  if not ok or not chat.chat or vim.bo.filetype == "copilot-chat" then
    return
  end
  chat.chat:set_source(vim.api.nvim_get_current_win())
end

local function open_chat()
  set_chat_source()
  require("CopilotChat").open()
end

local function toggle_chat()
  set_chat_source()
  require("CopilotChat").toggle()
end

return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      panel = {
        enabled = true,
        auto_refresh = true,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-CR>",
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = false,
          accept_word = "<M-l>",
          accept_line = "<M-L>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      filetypes = {
        help = false,
        gitcommit = true,
        markdown = true,
        yaml = true,
      },
    },
  },

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    cmd = {
      "CopilotChat",
      "CopilotChatOpen",
      "CopilotChatClose",
      "CopilotChatToggle",
      "CopilotChatStop",
      "CopilotChatReset",
      "CopilotChatExplain",
      "CopilotChatReview",
      "CopilotChatFix",
      "CopilotChatOptimize",
      "CopilotChatDocs",
      "CopilotChatTests",
    },
    keys = {
      { "<leader>aa", toggle_chat, desc = "Toggle AI chat" },
      { "<leader>aq", open_chat, desc = "Ask AI" },
      { "<leader>ae", "<cmd>CopilotChatExplain<cr>", mode = { "n", "v" }, desc = "Explain code" },
      { "<leader>ar", "<cmd>CopilotChatReview<cr>", mode = { "n", "v" }, desc = "Review code" },
      { "<leader>af", "<cmd>CopilotChatFix<cr>", mode = { "n", "v" }, desc = "Fix code" },
      { "<leader>ad", "<cmd>CopilotChatDocs<cr>", mode = { "n", "v" }, desc = "Write docs" },
      { "<leader>at", "<cmd>CopilotChatTests<cr>", mode = { "n", "v" }, desc = "Write tests" },
    },
    dependencies = {
      "zbirenbaum/copilot.lua",
      "nvim-lua/plenary.nvim",
    },
    opts = {
      resources = {
        "selection",
        "buffer:active",
      },
      window = {
        layout = "vertical",
        width = 0.4,
      },
    },
  },
}
