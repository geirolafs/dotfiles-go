# Chromium Module

Chromium browser configuration for Wayland and extension management.

## Structure

```
chromium/
├── .config/
│   └── chromium/
│       ├── chromium-flags.conf     # Wayland flags and runtime options
│       ├── extensions.md            # Documented list of installed extensions
│       └── extension-settings/      # (Optional) Exported extension configs
└── .local/
    └── bin/
        └── chromium-list-extensions # Utility to list/export extensions
```

## Files

### chromium-flags.conf
Command-line flags for Chromium. Currently enables Wayland support with:
- `--ozone-platform=wayland` - Native Wayland backend
- `--enable-features=WaylandWindowDecorations` - Wayland decorations

To add more flags (like loading unpacked extensions):
```bash
# Add to chromium-flags.conf
--load-extension=/path/to/extension1,/path/to/extension2
```

### extensions.md
Documents all installed Chromium extensions with:
- Extension names and versions
- Chrome Web Store IDs and URLs
- Installation instructions
- Purpose/description of each extension

This file serves as a reference when setting up Chromium on a new system, since extensions cannot be automatically installed via dotfiles.

### chromium-list-extensions
Utility script to extract and list currently installed extensions.

**Usage:**
```bash
# Human-readable format
chromium-list-extensions

# Markdown format (for updating extensions.md)
chromium-list-extensions markdown

# JSON format
chromium-list-extensions json

# Update extensions.md automatically
chromium-list-extensions markdown > ~/.dotfiles/chromium/.config/chromium/extensions.md
```

## Extension Management

### Installing Extensions
Extensions must be installed manually:

1. **From Chrome Web Store** (recommended):
   - Visit the URL listed in `extensions.md`
   - Click "Add to Chrome"

2. **From CRX file**:
   - Download `.crx` file
   - Go to `chrome://extensions`
   - Enable "Developer mode"
   - Drag and drop `.crx` file

3. **Unpacked extensions** (development):
   - Add to `chromium-flags.conf`: `--load-extension=/path/to/extension`
   - This loads the extension automatically on startup

### Backing Up Extension Settings
Some extensions allow exporting settings:

1. Check if extension has export/import feature
2. Export settings to JSON or file
3. Store in `extension-settings/` directory (create if needed)
4. Commit to dotfiles
5. Import manually on new system

### Updating Extension List
After installing or removing extensions:

```bash
# Update the extensions.md file
cd ~/.dotfiles
chromium-list-extensions markdown > chromium/.config/chromium/extensions.md

# Commit changes
git add chromium/.config/chromium/extensions.md
git commit -m "Update Chromium extension list"
```

## Deployment

```bash
# Deploy chromium module
cd ~/.dotfiles
stow chromium

# Verify deployment
ls -la ~/.config/chromium-flags.conf  # Should be symlink
which chromium-list-extensions        # Should be in PATH
```

## Notes

- **Extension binaries cannot be managed**: Chrome Web Store extensions are proprietary and cannot be stored in dotfiles
- **Extension IDs are stable**: The extension ID (hash) stays the same across installations
- **Flags file is plain text**: Can be edited directly or via symlink
- **Chromium profile data excluded**: `~/.config/chromium/` (the profile directory) is intentionally NOT managed by dotfiles as it contains cache, cookies, and authentication tokens

## Related Modules

- `brave/` - Brave browser configuration (also uses Chromium flags)
- `figma/` - Uses Chromium with custom flags for Figma app
