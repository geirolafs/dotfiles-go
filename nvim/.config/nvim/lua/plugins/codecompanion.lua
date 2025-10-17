-- CodeCompanion.nvim - Multi-Model AI Assistant
-- Supports Gemini CLI, Claude API, OpenAI, Ollama, and more
return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  cmd = {
    "CodeCompanion",
    "CodeCompanionChat",
    "CodeCompanionActions",
    "CodeCompanionCmd",
  },
  keys = {
    -- Main namespace under <leader>ag (AI Gemini / AI General)
    { "<leader>ag", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle AI Chat", mode = { "n", "v" } },
    { "<leader>aG", "<cmd>CodeCompanionChat<cr>", desc = "New AI Chat", mode = { "n", "v" } },
    { "<leader>ai", "<cmd>CodeCompanion<cr>", desc = "AI Inline", mode = { "n", "v" } },
    { "<leader>aA", "<cmd>CodeCompanionChat Add<cr>", desc = "Add to AI Chat", mode = "v" },
    { "<leader>aq", "<cmd>CodeCompanionActions<cr>", desc = "AI Quick Actions", mode = { "n", "v" } },
    { "<leader>aC", "<cmd>CodeCompanionCmd<cr>", desc = "AI Generate Command", mode = "n" },
  },
  opts = {
    adapters = {
      -- Configure Gemini CLI as Agent Client Protocol adapter
      acp = {
        gemini_cli = function()
          return require("codecompanion.adapters").extend("gemini_cli", {
            defaults = {
              auth_method = "gemini-api-key", -- or "oauth-personal" or "vertex-ai"
            },
            -- Optional: If you want to use 1Password or other secret manager
            -- env = {
            --   GEMINI_API_KEY = "cmd:op read op://personal/Gemini_API/credential --no-newline",
            -- },
          })
        end,
      },
    },
    display = {
      chat = {
        -- Match Claude Code's right-side layout
        window = {
          layout = "vertical", -- or "horizontal", "float"
          width = 0.30, -- 30% width (slightly wider than Claude's 26%)
          height = 0.90,
          relative = "editor",
          position = "right",
        },
      },
    },
    -- Optional: Set default adapter
    -- strategies = {
    --   chat = {
    --     adapter = "gemini_cli",
    --   },
    --   inline = {
    --     adapter = "gemini_cli",
    --   },
    -- },
  },
  config = function(_, opts)
    require("codecompanion").setup(opts)

    -- Optional: Add custom commands or additional keybindings
    vim.api.nvim_create_user_command("AIChatToggle", function()
      vim.cmd("CodeCompanionChat Toggle")
    end, { desc = "Toggle CodeCompanion Chat" })
  end,
}
