-- Pre-install all Omarchy colorscheme plugins so theme switching works seamlessly
local colorscheme_plugins = {
  { "rebelot/kanagawa.nvim" },
  { "ellisonleao/gruvbox.nvim" },
  { "neanias/everforest-nvim" },
  { "rose-pine/neovim", name = "rose-pine" },
  { "tahayvr/matteblack.nvim" },
}

-- Load Omarchy theme dynamically if available
local omarchy_theme_file = vim.fn.expand("~/.config/omarchy/current/theme/neovim.lua")

if vim.fn.filereadable(omarchy_theme_file) == 1 then
  local ok, theme_config = pcall(dofile, omarchy_theme_file)
  if ok and theme_config then
    -- Merge colorscheme plugins with Omarchy theme config
    for _, plugin in ipairs(colorscheme_plugins) do
      table.insert(theme_config, plugin)
    end
    return theme_config
  end
end

-- Fallback to tokyonight if Omarchy theme isn't available
return vim.list_extend(colorscheme_plugins, {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
})
