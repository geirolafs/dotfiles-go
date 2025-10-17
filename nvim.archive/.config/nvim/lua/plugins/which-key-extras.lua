-- Enhanced Which-Key Configuration
--
-- This extends the default LazyVim which-key setup with better organization
-- for all the extras we've added. Press <space> to see the menu!
--
-- NEW KEYBINDINGS QUICK REFERENCE:
-- ================================
--
-- AI Assistants:
--   <leader>ac    - Toggle Claude Code terminal
--   <leader>ab    - Add buffer to Claude
--   <leader>as    - Send selection to Claude (visual)
--   <leader>aa    - Accept Claude diff
--   <leader>ag    - Toggle AI Chat (CodeCompanion/Gemini)
--   <leader>aG    - New AI Chat buffer
--   <leader>ai    - AI Inline transformation
--   <leader>aq    - AI Quick actions menu
--   <leader>aA    - Add selection to AI chat (visual)
--
-- File & Project Management:
--   <leader>fp    - Switch between projects (fuzzy search recent projects)
--   <leader>fm    - Open mini.files at current file location
--   <leader>fM    - Open mini.files at working directory
--
-- Yank/Paste (Copy/Paste):
--   <leader>p     - Open yank history (see all recent copies)
--   [y / ]y       - Cycle through yank history after pasting
--   p / P         - Smart paste after/before cursor
--
-- Code Actions:
--   <leader>cr    - Rename with preview (inc-rename)
--   <leader>cp    - Copy file path (custom)
--
-- Navigation:
--   [c / ]c       - Jump to previous/next context (function/class)
--   s / S         - Flash jump / treesitter jump
--
-- Movement (No leader key):
--   Alt+j / Alt+k - Move current line down/up
--   Alt+h / Alt+l - Move selection left/right (in visual mode)
--
-- In mini.files explorer:
--   g.            - Toggle hidden files
--   gc            - Change working directory
--   <C-w>s / v    - Open in split

return {
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        -- Add better descriptions for new features
        { "<leader>p", desc = "Yank History", mode = { "n", "x" } },

        -- AI Assistant groups
        { "<leader>a", group = "AI" },
        { "<leader>ag", desc = "Toggle AI Chat" },
        { "<leader>aG", desc = "New AI Chat" },
        { "<leader>ai", desc = "AI Inline" },
        { "<leader>aq", desc = "AI Quick Actions" },
        { "<leader>aA", desc = "Add to AI Chat", mode = "v" },

        -- File/Find group already exists, but we can add subgroups if needed
        { "<leader>fp", desc = "Projects" },
        { "<leader>fm", desc = "Mini Files (Current)" },
        { "<leader>fM", desc = "Mini Files (Root)" },

        -- Context navigation
        { "[c", desc = "Previous Context" },
        { "]c", desc = "Next Context" },

        -- Yank cycling
        { "[y", desc = "Cycle Yank Forward" },
        { "]y", desc = "Cycle Yank Backward" },
      },
    },
  },
}
