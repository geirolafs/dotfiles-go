-- Claude Code Integration for Neovim
return {
  -- Claude Code integration using official protocol
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    keys = {
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept Claude Code diff" },
    },
    opts = {
      -- Default configuration
      terminal = {
        position = "right",
        size = 80,
      },
    },
  },
}