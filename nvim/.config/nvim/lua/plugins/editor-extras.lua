-- Editor Enhancement Extras
--
-- This file imports LazyVim's quality-of-life editor improvements.
-- These extras enhance navigation, editing, and overall developer experience.

return {
  -- ========================================
  -- Code Navigation & Highlighting
  -- ========================================

  -- Illuminate: Automatically highlight matching words under cursor
  -- Shows: All occurrences of the symbol under cursor across the buffer
  -- Useful for: Quickly seeing where variables/functions are used
  -- Note: Works with LSP for semantic highlighting
  { import = "lazyvim.plugins.extras.editor.illuminate" },

  -- Treesitter Context: Show current function/class at top of window
  -- Shows: Sticky header with current scope (function name, class, etc.)
  -- Useful for: Long files where you scroll past function definitions
  -- Keybinding: [c / ]c to jump between contexts
  { import = "lazyvim.plugins.extras.ui.treesitter-context" },

  -- ========================================
  -- Editing Enhancements
  -- ========================================

  -- Inc-Rename: Preview symbol renames before applying
  -- Shows: Live preview of what will change when renaming
  -- Useful for: Safe refactoring without surprises
  -- Keybinding: <leader>cr (rename with preview)
  { import = "lazyvim.plugins.extras.editor.inc-rename" },

  -- Yanky: Better yank/paste with history
  -- Adds: Yank ring, cycle through previous copies
  -- Useful for: Access previously copied text without re-copying
  -- Keybinding: <leader>p (yank history picker)
  { import = "lazyvim.plugins.extras.coding.yanky" },

  -- Mini Move: Move lines and blocks with keyboard shortcuts
  -- Keybindings:
  --   Alt+h/j/k/l - Move current line/selection left/down/up/right
  -- Useful for: Quick code reorganization without cut/paste
  { import = "lazyvim.plugins.extras.editor.mini-move" },

  -- ========================================
  -- File & Project Management
  -- ========================================

  -- Project: Project switcher with history
  -- Adds: Remember recent projects, quick switching
  -- Keybinding: <leader>fp (fuzzy find projects)
  -- Useful for: Working across multiple codebases
  -- Features:
  --   - Ctrl-s: Search in selected project
  --   - Ctrl-w: Change working directory
  --   - Ctrl-d: Delete from history
  { import = "lazyvim.plugins.extras.util.project" },

  -- Mini Files: Alternative file explorer with Miller columns
  -- Shows: Multi-column directory view like macOS Finder
  -- Keybindings:
  --   <leader>fm - Open in current file's directory
  --   <leader>fM - Open in working directory
  --   g. - Toggle hidden files
  --   gc - Change working directory
  --   <C-w>s/v - Open in split
  -- Features:
  --   - Live file preview
  --   - In-place rename (press 'i')
  --   - Create/delete files
  -- Note: Coexists with neo-tree (<leader>e) - use whichever you prefer!
  { import = "lazyvim.plugins.extras.editor.mini-files" },
}
