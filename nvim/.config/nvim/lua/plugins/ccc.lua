return {
  {
    "uga-rosa/ccc.nvim",
    event = "VeryLazy",
    config = function()
      local ccc = require("ccc")
      ccc.setup({
        -- Enable highlighter (shows colors in your code)
        highlighter = {
          auto_enable = true,
          lsp = true,
        },
        -- Multiple output formats (press 'o' in picker to cycle through)
        outputs = {
          ccc.output.hex,
          ccc.output.css_rgb,
          ccc.output.css_hsl,
          ccc.output.css_hwb,
          ccc.output.css_lab,
          ccc.output.css_lch,
          ccc.output.css_oklab,
          ccc.output.css_oklch,
        },
      })
    end,
    keys = {
      -- Press <leader>pc to open color picker
      { "<leader>pc", "<cmd>CccPick<cr>", desc = "Color Picker" },
      -- Convert existing color under cursor to different format
      { "<leader>pC", "<cmd>CccConvert<cr>", desc = "Convert Color" },
    },
  },
}
