# System Tools Inventory

This document catalogs all CLI tools, development runtimes, and utilities installed on this system.

## Version Management

### mise (Version Manager)
**Location**: `~/.config/mise/` (symlinked from `~/.dotfiles/mise/.config/mise/`)
**Purpose**: Manages per-project and global versions of development tools
**Config**: `config.toml`

**Managed Tools**:
- **JavaScript/TypeScript**: Node.js (lts), Bun (latest), Deno (latest)
- **Python**: Python 3.13, uv (latest)
- **Systems Programming**: Rust (latest), Zig (latest), Go (latest)
- **Per-project support**: Automatically reads `.nvmrc`, `.node-version`, `.python-version`, etc.

**Why mise?**
- Per-project version isolation (no conflicts between projects)
- Automatic version switching when changing directories
- Single tool for all language runtimes
- Replaces nvm, pyenv, rbenv, etc.

## LLM & AI Tools

### Ollama
**Version**: 0.4.4
**Location**: `/usr/bin/ollama` (system package)
**Purpose**: Run large language models locally
**Management**: System-managed via pacman (requires systemd service)

**Usage**:
```bash
ollama list              # List installed models
ollama run <model>       # Run a model
systemctl status ollama  # Check service status
```

### Claude CLI
**Version**: 2.0.17
**Location**: `~/.local/bin/claude` → `~/.local/share/claude/versions/2.0.17`
**Purpose**: Anthropic's Claude Code - AI-powered CLI coding assistant
**Management**: Managed via npm/npx (`@anthropic-ai/claude-code`)

**Usage**:
```bash
claude --version         # Check version
claude                   # Start interactive session
```

### aichat (Optional)
**Status**: Available in mise registry but not installed
**Purpose**: CLI for multiple LLM providers (OpenAI, Anthropic, Ollama, etc.)

To install: Uncomment `aichat = "latest"` in `~/.config/mise/config.toml`

## Container & DevOps

### Docker
**Version**: 28.4.0
**Location**: `/usr/bin/docker` (system package)
**Components**:
- Docker Engine (28.4.0)
- Docker Compose (2.39.3)
- Docker Buildx (0.28.0)

**Management**: System-managed via pacman (requires systemd service)

**Usage**:
```bash
docker ps                # List containers
docker compose up        # Start compose stack
systemctl status docker  # Check service status
```

### lazydocker
**Version**: 0.24.1
**Location**: `/usr/bin/lazydocker` (system package)
**Purpose**: Terminal UI for Docker management
**Config**: `~/.dotfiles/lazydocker/`

**Usage**:
```bash
lazydocker              # Launch TUI
```

## Python Ecosystem

### Python (via mise)
**Version**: 3.13.7
**Location**: `~/.local/share/mise/installs/python/3.13.7/`
**Management**: mise-managed (per-project versions supported)

### uv (via mise)
**Purpose**: Fast Python package and project manager (written in Rust)
**Management**: mise-managed (was in `~/.local/bin/`, now centralized)
**Replaces**: pip, pip-tools, virtualenv, poetry (partially)

**Usage**:
```bash
uv pip install <package>  # Install packages
uv venv                   # Create virtual environment
uv run <script>           # Run in isolated environment
```

### ruff (via mise)
**Purpose**: Fast Python linter and formatter (written in Rust)
**Management**: mise-managed
**Replaces**: flake8, black, isort, pylint (partially)

**Usage**:
```bash
ruff check .              # Lint code
ruff format .             # Format code
ruff check --fix .        # Auto-fix issues
```

### Poetry
**Version**: poetry-core 2.1.3
**Status**: System-managed (available but not primary tool)
**Alternative**: Consider using `uv` for most tasks

## Development Runtimes

### Rust (via mise)
**Management**: mise-managed (was system-managed at 1.89.0)
**Components**: rustc, cargo, rustup equivalent
**Per-project**: Add `rust = "1.89.0"` to project `.mise.toml`

**Usage**:
```bash
cargo build               # Build project
cargo run                 # Run project
cargo test                # Run tests
```

### Zig (via mise)
**Management**: mise-managed (was system-managed at 0.16.0-dev)
**Purpose**: Systems programming language
**Per-project**: Add `zig = "0.16.0"` to project `.mise.toml`

**Usage**:
```bash
zig build                 # Build project
zig test                  # Run tests
```

### Go (via mise)
**Management**: mise-managed
**Purpose**: Go programming language
**Per-project**: Add `go = "1.23"` to project `.mise.toml`

**Usage**:
```bash
go build                  # Build project
go test                   # Run tests
go mod tidy               # Clean dependencies
```

### Deno (via mise)
**Management**: mise-managed
**Purpose**: Secure TypeScript/JavaScript runtime
**Alternative to**: Node.js for modern JS/TS projects

**Usage**:
```bash
deno run script.ts        # Run TypeScript directly
deno task dev             # Run tasks
deno test                 # Run tests
```

## CLI Utilities

### Modern Unix Tools
**Management**: System-managed via pacman (stable versions)

| Tool | Purpose | Replaces | Version |
|------|---------|----------|---------|
| **bat** | Syntax-highlighted cat | cat | 0.25.0 |
| **eza** | Modern ls with colors | ls | 0.23.3 |
| **fd** | Fast file finder | find | 10.3.0 |
| **rg** (ripgrep) | Fast text search | grep | Latest |
| **fzf** | Fuzzy finder | - | 0.65.2 |
| **jq** | JSON processor | - | Latest |

**Usage examples**:
```bash
bat README.md            # View file with syntax highlighting
eza -la                  # List files with colors and icons
fd "pattern"             # Find files quickly
rg "search term"         # Search text in files
fzf                      # Interactive fuzzy finder
jq '.' data.json         # Pretty-print JSON
```

### Git Tools

#### lazygit
**Version**: 0.55.1
**Location**: `/usr/bin/lazygit` (system package)
**Purpose**: Terminal UI for Git operations
**Config**: `~/.dotfiles/lazygit/`

**Usage**:
```bash
lazygit                  # Launch TUI
```

#### GitHub CLI (gh)
**Location**: `/usr/bin/gh` (system package)
**Purpose**: GitHub operations from command line

**Usage**:
```bash
gh pr list               # List pull requests
gh issue create          # Create issue
gh repo view             # View repository
```

### Shell Enhancements

#### starship
**Location**: `/usr/bin/starship` (system package)
**Purpose**: Fast, customizable shell prompt
**Config**: `~/.dotfiles/starship/.config/starship.toml`

#### zoxide
**Location**: `/usr/bin/zoxide` (system package)
**Purpose**: Smarter cd command (learns your habits)

**Usage**:
```bash
z project                # Jump to frequently used directory
zi                       # Interactive directory selection
```

## Editors

### Neovim
**Location**: `/usr/bin/nvim` (system package)
**Config**: `~/.dotfiles/nvim/.config/nvim/`
**Purpose**: Primary text editor with extensive Lua configuration

### Vim
**Location**: `/usr/bin/vim` (system package)
**Purpose**: Fallback editor

## Custom Scripts

**Location**: `~/.dotfiles/scripts/.local/bin/` (symlinked to `~/.local/bin/`)

### Battery & Power
- `battery-monitor` - Monitor battery status

### Font Management
- `font-activate` - Activate fonts
- `font-deactivate` - Deactivate fonts
- `font-list-active` - List active fonts
- `font-refresh` - Refresh font cache
- `font-utils.sh` - Font utility functions
- `compare-fontlib` - Compare font libraries
- `remove-duplicate-fonts` - Clean up duplicate fonts

### Cloud & Sync
- `dropbox-mount` - Mount Dropbox via rclone
- `dropbox-unmount` - Unmount Dropbox
- `dropbox-sync-all` - Sync all Dropbox files
- `dropbox-sync-fonts` - Sync fonts from Dropbox

### Audio
- `easyeffects-manage` - Manage EasyEffects profiles
- `easyeffects-set-default` - Set default audio profile

### Network & Remote
- `imac-vnc-start` - Start VNC to iMac
- `imac-vnc-stop` - Stop VNC connection
- `nordvpn-tui` - TUI for NordVPN

### Applications
- `figma-agent` - Figma desktop agent
- `figma-chromium-trackpad-fix` - Fix trackpad in Figma
- `messenger-chromium` - Launch Messenger in Chromium

### System
- `keyboard-backlight-swayidle.sh` - Manage keyboard backlight
- `omarchy-launch-bluetooth` - Bluetooth launcher
- `omarchy-launch-wifi` - WiFi launcher

## Installation Notes

### Adding New Tools to mise
Edit `~/.config/mise/config.toml` and run:
```bash
mise install              # Install all configured tools
mise use -g <tool>@<ver>  # Add tool to global config
```

### System Package Management
```bash
pacman -Syu               # Update system packages
pacman -Ss <package>      # Search for package
pacman -S <package>       # Install package
pacman -R <package>       # Remove package
```

### Custom Script Management
Scripts are managed via GNU Stow from `~/.dotfiles/`:
```bash
cd ~/.dotfiles
stow scripts              # Symlink scripts to ~/.local/bin/
```

## Tool Management Philosophy

### mise-managed Tools
**When to use mise**:
- Development runtimes (Node.js, Python, Rust, Go, etc.)
- Tools needing per-project version isolation
- Frequently updated development tools
- Cross-platform tools available in mise registry

**Benefits**:
- Per-project version locking
- Automatic version switching
- Consistent across machines
- No sudo required

### System-managed Tools (pacman)
**When to use system packages**:
- System services (Docker, Ollama)
- Stable CLI utilities (bat, eza, fd, rg)
- Tools with system dependencies
- Tools needing systemd integration

**Benefits**:
- System-wide availability
- Automatic security updates
- Integration with system services
- Package manager dependency resolution

### Custom Scripts
**When to create custom scripts**:
- Workflow automation
- System-specific configurations
- Integration between tools
- Convenience wrappers

**Location**: `~/.dotfiles/scripts/.local/bin/`
**Management**: GNU Stow for symlinking

## See Also

- **CLAUDE.md** - AI assistance guidelines for this repository
- **README.md** - Dotfiles setup and installation instructions
- Package manager configs in respective dotfile directories
