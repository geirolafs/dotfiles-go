return {
  {
    "uga-rosa/ccc.nvim",
    event = "VeryLazy",
    config = function()
      local ccc = require("ccc")
      ccc.setup({
        -- Enable highlight for color codes
        highlighter = {
          auto_enable = true,
          lsp = true,
        },
      })
    end,
    keys = {
      { "<leader>cp", "<cmd>CccPick<cr>", desc = "Pick Color" },
      { "<leader>cc", "<cmd>CccConvert<cr>", desc = "Convert Color" },
      { "<leader>ct", "<cmd>CccHighlighterToggle<cr>", desc = "Toggle Color Highlight" },
    },
  },
}
