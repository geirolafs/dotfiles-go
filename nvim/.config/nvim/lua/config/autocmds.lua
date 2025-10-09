-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Disable LazyVim's spell checking autocmds
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

    -- Fix bufferline tab styling when neo-tree auto-opens
    -- When opening nvim with a directory (e.g., `nvim .`), neo-tree auto-loads before
    -- bufferline finishes initializing. This causes bufferline's offset highlights to
    -- reference incomplete colorscheme data. Solution: Regenerate highlights after everything loads.
    vim.defer_fn(function()
      -- Check if neo-tree is loaded (indicates directory startup)
      local has_neotree = false
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "neo-tree" then
          has_neotree = true
          break
        end
      end

      -- Only reload colorscheme if neo-tree is present
      if has_neotree and vim.g.colors_name then
        -- Simply reload the colorscheme - this clears and regenerates all highlights
        -- This is exactly what the user does manually with :colorscheme omarchy-dynamic
        vim.cmd.colorscheme(vim.g.colors_name)
      end
    end, 50) -- 50ms delay after VeryLazy
  end,
})
