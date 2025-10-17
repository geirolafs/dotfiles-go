-- Language Support Extras
--
-- This file imports LazyVim's pre-configured language extras for better development experience.
-- Each extra bundles together LSP servers, Tree-sitter parsers, formatters, and linters
-- specific to each language/framework.

return {
  -- ========================================
  -- Essential Language Support
  -- ========================================

  -- JSON/JSONC support with syntax highlighting and LSP
  -- Adds: json/jsonc parsers, jsonls language server, schemastore for validation
  -- Fixes: Missing syntax highlighting in *.json files
  { import = "lazyvim.plugins.extras.lang.json" },

  -- Enhanced TypeScript/JavaScript support
  -- Adds: tsserver LSP, advanced inlay hints, better diagnostics, debugging support
  -- Works with: Your existing web-development.lua TypeScript config
  { import = "lazyvim.plugins.extras.lang.typescript" },

  -- Tailwind CSS support with v4 compatibility
  -- Adds: tailwindcss-language-server, class completion, color previews, sorting
  -- Works with: Your existing Tailwind config in web-development.lua
  { import = "lazyvim.plugins.extras.lang.tailwind" },

  -- Markdown support for documentation
  -- Adds: markdown parser, preview, formatting, TOC generation
  -- Useful for: README files, documentation, note-taking
  { import = "lazyvim.plugins.extras.lang.markdown" },

  -- ========================================
  -- Linting & Formatting
  -- ========================================

  -- ESLint integration for code quality checks
  -- Adds: eslint-lsp, diagnostics in gutter, auto-fix on save (optional)
  -- Note: Won't conflict with Biome formatting - ESLint handles linting, Biome handles formatting
  -- Disable auto-format if needed: vim.g.lazyvim_eslint_auto_format = false
  { import = "lazyvim.plugins.extras.linting.eslint" },

  -- Prettier formatting support
  -- Adds: Better Prettier integration for CSS, HTML, YAML, etc.
  -- Works with: Your existing conform.nvim config in web-development.lua
  { import = "lazyvim.plugins.extras.formatting.prettier" },
}
