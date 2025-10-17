return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    local util = require("conform.util")

    -- Override LazyVim's biome extra to use biome-check instead of biome
    -- biome: formatting only
    -- biome-check: formatting + linting fixes (includes useSortedClasses for CSS class sorting)

    opts.formatters_by_ft = opts.formatters_by_ft or {}

    -- Replace (not append) the formatter for these filetypes
    opts.formatters_by_ft.javascript = { "biome-check" }
    opts.formatters_by_ft.javascriptreact = { "biome-check" }
    opts.formatters_by_ft.typescript = { "biome-check" }
    opts.formatters_by_ft.typescriptreact = { "biome-check" }
    opts.formatters_by_ft.json = { "biome-check" }
    opts.formatters_by_ft.jsonc = { "biome-check" }
    opts.formatters_by_ft.css = { "biome-check" }

    -- Override biome-check to use file-based formatting instead of stdin
    -- This works around Biome v2's stdin bug that prevents linter fixes from being applied
    opts.formatters = opts.formatters or {}
    opts.formatters["biome-check"] = {
      require_cwd = true,
      cwd = util.root_file({ "biome.json", "biome.jsonc" }),
      stdin = false, -- Disable stdin to work around Biome v2 bug
      -- When stdin is false, conform creates a temp file and passes it as $FILENAME
      args = { "check", "--write", "$FILENAME" },
    }

    return opts
  end,
}
