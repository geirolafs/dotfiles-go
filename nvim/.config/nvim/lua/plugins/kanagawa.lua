return {
  -- Add kanagawa colorscheme
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        compile = true, -- enable compiling the colorscheme
        undercurl = true, -- enable undercurls
        commentStyle = { italic = false, bold = false },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = false },
        typeStyle = {},
        transparent = false, -- do not set background color
        dimInactive = false, -- dim inactive window `:h hl-NormalNC`
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        colors = { -- add/modify theme and palette colors
          palette = {},
          theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
        },
        overrides = function() -- add/modify highlights
          return {
            LineNr = { bg = "none" }, -- Regular line numbers
            CursorLineNr = { bg = "none" }, -- Current line number
            SignColumn = { bg = "none" }, -- Sign column (git signs, etc.)
            FoldColumn = { bg = "none" }, -- Fold column
          }
        end,
        theme = "wave", -- Load "wave" theme when 'background' option is not set
        background = { -- map the value of 'background' option to a theme
          dark = "dragon", -- try "dragon" or "wave"
          light = "lotus",
        },
      })

      vim.cmd("colorscheme kanagawa")
      -- vim.cmd("colorscheme kanagawa-wave")   -- default dark theme
      -- vim.cmd("colorscheme kanagawa-dragon") -- darker variant
      -- vim.cmd("colorscheme kanagawa-lotus")  -- light variant
    end,
  },

  -- Configure LazyVim to use kanagawa
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa-dragon",
    },
  },
}
