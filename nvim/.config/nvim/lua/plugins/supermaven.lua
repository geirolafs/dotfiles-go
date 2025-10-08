-- Supermaven AI Autocomplete
--
-- Features:
-- - Ultra-fast inference (300ms avg response time)
-- - Inline ghost text suggestions
-- - Multi-line completions
-- - Context-aware suggestions (1M token context window)
--
-- Keybindings:
-- - Tab: Accept suggestion
-- - Alt-]: Accept word
-- - Alt-[: Clear suggestion
-- - Ctrl-Space: Trigger completion menu (nvim-cmp)
--
-- Setup:
-- 1. Install plugin: :Lazy sync
-- 2. Authenticate: :SupermavenLogin
-- 3. Start coding and press Tab to accept suggestions

return {
  -- Supermaven AI completion engine
  {
    "supermaven-inc/supermaven-nvim",
    event = "VeryLazy", -- Load shortly after startup (better for :SupermavenLogin)
    opts = {
      keymaps = {
        accept_suggestion = "<Tab>",
        clear_suggestion = "<A-[>",
        accept_word = "<A-]>",
      },
      ignore_filetypes = { "markdown", "text" }, -- Disable in text files
      color = {
        suggestion_color = "#808080", -- Gray ghost text
        cterm = 244,
      },
      log_level = "warn", -- Reduce noise in logs
      disable_inline_completion = false, -- Show inline suggestions
      disable_keymaps = false,
    },
  },

  -- Integrate Supermaven with nvim-cmp completion menu
  {
    "nvim-cmp",
    dependencies = {
      "supermaven-inc/supermaven-nvim",
    },
    ---@param opts table
    opts = function(_, opts)
      -- Add Supermaven to completion sources
      opts.sources = opts.sources or {}
      table.insert(opts.sources, 1, {
        name = "supermaven",
        group_index = 1,
        priority = 100,
      })

      -- Customize formatting to show Supermaven icon
      opts.formatting = opts.formatting or {}
      local format_kinds = opts.formatting.format
      opts.formatting.format = function(entry, item)
        if format_kinds then
          format_kinds(entry, item)
        end

        -- Add Supermaven icon
        if entry.source.name == "supermaven" then
          item.kind = " Supermaven"
          item.kind_hl_group = "CmpItemKindSupermaven"
        end

        return item
      end

      return opts
    end,
  },
}
