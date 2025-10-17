return {
  {
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
      -- Main AI namespace (shared with Claude Code)
      { "<leader>a", nil, desc = "AI/Claude Code" },

      -- CodeCompanion Chat (Gemini CLI, Claude API, etc.)
      { "<leader>ag", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle AI Chat", mode = { "n", "v" } },
      { "<leader>aG", "<cmd>CodeCompanionChat<cr>", desc = "New AI Chat", mode = { "n", "v" } },

      -- Inline and Actions
      { "<leader>ai", "<cmd>CodeCompanion<cr>", desc = "AI Inline", mode = { "n", "v" } },
      { "<leader>aq", "<cmd>CodeCompanionActions<cr>", desc = "AI Quick Actions", mode = { "n", "v" } },

      -- Visual mode additions
      { "<leader>aA", "<cmd>CodeCompanionChat Add<cr>", desc = "Add to AI Chat", mode = "v" },

      -- Command generation
      { "<leader>ax", "<cmd>CodeCompanionCmd<cr>", desc = "AI Generate Command", mode = "n" },
    },
    opts = {
      -- NOTE: The log_level is in `opts.opts`
      opts = {
        log_level = "DEBUG", -- or "TRACE"
      },
      adapters = {
        -- Configure Gemini CLI as Agent Client Protocol adapter
        gemini_cli = function()
          return require("codecompanion.adapters").extend("gemini_cli", {
            -- Optional: Configure auth method if needed
            -- env = {
            --   GEMINI_API_KEY = "your-api-key-here",
            -- },
          })
        end,
      },
      display = {
        chat = {
          window = {
            layout = "vertical",
            width = 0.30, -- 30% width
            height = 0.90,
            relative = "editor",
            position = "right", -- Match Claude Code's layout
          },
        },
      },
    },
    config = function(_, opts)
      require("codecompanion").setup(opts)
    end,
  },
}
