-- Omarchy Dynamic Colorscheme
-- Reads colors from ~/.config/omarchy/current/theme/custom_theme.json

-- Clear existing highlights
vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

vim.g.colors_name = "omarchy-dynamic"

-- Helper to read JSON file
local function read_json(filepath)
  local file = io.open(vim.fn.expand(filepath), "r")
  if not file then
    return nil
  end
  local content = file:read("*all")
  file:close()

  local ok, decoded = pcall(vim.fn.json_decode, content)
  if ok then
    return decoded
  end
  return nil
end

-- Read theme JSON
local theme_json = read_json("~/.config/omarchy/current/theme/custom_theme.json")

-- Fallback colors if JSON not found
local colors = {
  bg = "#121212",
  fg = "#E6E3D9",
  dim_fg = "#4c4c4c",
  black = "#333333",
  red = "#d32c21",
  green = "#A1D8FF",
  yellow = "#DCFFB2",
  blue = "#21a3ff",
  magenta = "#f9c9c9",
  cyan = "#f18484",
  white = "#eaeaea",
  bright_black = "#333333",
  bright_red = "#EC5B5B",
  bright_green = "#fff507",
  bright_yellow = "#FFF9B9",
  bright_blue = "#54b8ff",
  bright_magenta = "#FFE8E8",
  bright_cyan = "#eaecec",
  bright_white = "#d8d8d8",
}

-- Extract colors from JSON if available
if theme_json then
  if theme_json.colors and theme_json.colors.primary then
    colors.bg = theme_json.colors.primary.background or colors.bg
    colors.fg = theme_json.colors.primary.foreground or colors.fg
  end

  if theme_json.apps and theme_json.apps.alacritty and theme_json.apps.alacritty.colors then
    local alacritty_colors = theme_json.apps.alacritty.colors

    if alacritty_colors.primary then
      colors.dim_fg = alacritty_colors.primary.dim_foreground or colors.dim_fg
    end

    if alacritty_colors.normal then
      colors.black = alacritty_colors.normal.black or colors.black
      colors.red = alacritty_colors.normal.red or colors.red
      colors.green = alacritty_colors.normal.green or colors.green
      colors.yellow = alacritty_colors.normal.yellow or colors.yellow
      colors.blue = alacritty_colors.normal.blue or colors.blue
      colors.magenta = alacritty_colors.normal.magenta or colors.magenta
      colors.cyan = alacritty_colors.normal.cyan or colors.cyan
      colors.white = alacritty_colors.normal.white or colors.white
    end

    if alacritty_colors.bright then
      colors.bright_black = alacritty_colors.bright.black or colors.bright_black
      colors.bright_red = alacritty_colors.bright.red or colors.bright_red
      colors.bright_green = alacritty_colors.bright.green or colors.bright_green
      colors.bright_yellow = alacritty_colors.bright.yellow or colors.bright_yellow
      colors.bright_blue = alacritty_colors.bright.blue or colors.bright_blue
      colors.bright_magenta = alacritty_colors.bright.magenta or colors.bright_magenta
      colors.bright_cyan = alacritty_colors.bright.cyan or colors.bright_cyan
      colors.bright_white = alacritty_colors.bright.white or colors.bright_white
    end
  end
end

-- Apply highlight groups
local hi = vim.api.nvim_set_hl

-- Editor highlights
hi(0, "Normal", { fg = colors.fg, bg = colors.bg })
hi(0, "NormalFloat", { fg = colors.fg, bg = colors.bg })
hi(0, "Comment", { fg = colors.dim_fg, italic = true })
hi(0, "LineNr", { fg = colors.dim_fg })
-- hi(0, "Cursor", { reverse = true })
-- hi(0, "TermCursor", { reverse = true })
-- hi(0, "TermCursorNC", { reverse = true })
-- hi(0, "CursorLine", { bg = colors.bright_black })
hi(0, "CursorLineNr", { fg = colors.bright_white, bold = false })
hi(0, "CursorColumn", { bg = colors.bright_black })
hi(0, "Visual", { fg = colors.bg, bg = colors.bright_yellow })
hi(0, "VisualNOS", { fg = colors.bg, bg = colors.bright_yellow })
hi(0, "Search", { fg = colors.bg, bg = colors.yellow })
hi(0, "IncSearch", { fg = colors.bg, bg = colors.bright_green })
hi(0, "MatchParen", { fg = colors.cyan, bold = true })

-- Syntax highlighting
hi(0, "Constant", { fg = colors.cyan })
hi(0, "String", { fg = colors.green })
hi(0, "Number", { fg = colors.magenta })
hi(0, "Boolean", { fg = colors.magenta })
hi(0, "Float", { fg = colors.magenta })

hi(0, "Identifier", { fg = colors.fg })
hi(0, "Function", { fg = colors.blue })

hi(0, "Statement", { fg = colors.cyan })
hi(0, "Keyword", { fg = colors.cyan })
hi(0, "Operator", { fg = colors.cyan })

hi(0, "PreProc", { fg = colors.magenta })
hi(0, "Include", { fg = colors.magenta })
hi(0, "Define", { fg = colors.magenta })

hi(0, "Type", { fg = colors.blue })
hi(0, "StorageClass", { fg = colors.blue })
hi(0, "Structure", { fg = colors.blue })

hi(0, "Special", { fg = colors.yellow })
hi(0, "SpecialChar", { fg = colors.yellow })
hi(0, "Tag", { fg = colors.yellow })

hi(0, "Error", { fg = colors.red, bold = true })
hi(0, "Todo", { fg = colors.yellow, bold = true })

-- UI elements
hi(0, "Pmenu", { fg = colors.fg, bg = colors.bright_black })
hi(0, "PmenuSel", { fg = colors.bg, bg = colors.blue })
hi(0, "StatusLine", { fg = colors.fg, bg = colors.bright_black })
hi(0, "StatusLineNC", { fg = colors.dim_fg, bg = colors.black })
hi(0, "TabLine", { fg = colors.dim_fg, bg = colors.black })
hi(0, "TabLineSel", { fg = colors.fg, bg = colors.bg })
hi(0, "VertSplit", { fg = colors.bright_black })

-- Git signs
hi(0, "DiffAdd", { fg = colors.green })
hi(0, "DiffChange", { fg = colors.yellow })
hi(0, "DiffDelete", { fg = colors.red })
hi(0, "DiffText", { fg = colors.blue })

-- Neo-tree file explorer
hi(0, "NeoTreeNormal", { fg = colors.fg, bg = colors.bg })
hi(0, "NeoTreeNormalNC", { fg = colors.fg, bg = colors.bg })
hi(0, "NeoTreeDirectoryIcon", { fg = colors.blue })
hi(0, "NeoTreeDirectoryName", { fg = colors.blue })
hi(0, "NeoTreeFileName", { fg = colors.fg })
hi(0, "NeoTreeFileIcon", { fg = colors.cyan })
hi(0, "NeoTreeRootName", { fg = colors.magenta, bold = true })
hi(0, "NeoTreeSymbolicLinkTarget", { fg = colors.cyan })
hi(0, "NeoTreeGitAdded", { fg = colors.green })
hi(0, "NeoTreeGitModified", { fg = colors.yellow })
hi(0, "NeoTreeGitDeleted", { fg = colors.red })
hi(0, "NeoTreeGitConflict", { fg = colors.red, bold = true })
hi(0, "NeoTreeGitUntracked", { fg = colors.dim_fg })
hi(0, "NeoTreeGitIgnored", { fg = colors.dim_fg, italic = true })
hi(0, "NeoTreeIndentMarker", { fg = colors.bright_black })
hi(0, "NeoTreeExpander", { fg = colors.bright_black })

-- Terminal colors
vim.g.terminal_color_0 = colors.black
vim.g.terminal_color_1 = colors.red
vim.g.terminal_color_2 = colors.green
vim.g.terminal_color_3 = colors.yellow
vim.g.terminal_color_4 = colors.blue
vim.g.terminal_color_5 = colors.magenta
vim.g.terminal_color_6 = colors.cyan
vim.g.terminal_color_7 = colors.white
vim.g.terminal_color_8 = colors.bright_black
vim.g.terminal_color_9 = colors.bright_red
vim.g.terminal_color_10 = colors.bright_green
vim.g.terminal_color_11 = colors.bright_yellow
vim.g.terminal_color_12 = colors.bright_blue
vim.g.terminal_color_13 = colors.bright_magenta
vim.g.terminal_color_14 = colors.bright_cyan
vim.g.terminal_color_15 = colors.bright_white
