---
name: arch
description: >
  REQUIRED for end-user customization of Linux desktop, window manager, or system config.
  Use when editing ~/.config/hypr/, ~/.config/waybar/, ~/.config/walker/,
  ~/.config/alacritty/, ~/.config/kitty/, ~/.config/ghostty/, ~/.config/mako/,
  or ~/.config/theme/. Triggers: Hyprland, window rules, animations, keybindings,
  monitors, gaps, borders, blur, opacity, waybar, walker, terminal config, themes,
  wallpaper, night light, idle, lock screen, screenshots, layer rules, workspace
  settings, display config, and user-facing arch commands. Excludes Omarchy
  source development in ~/.local/share/arch/ and arch-dev-* workflows.
---

# Omarchy Skill

Manage [Omarchy](https://arch.org/) Linux systems - a beautiful, modern, opinionated Arch Linux distribution with Hyprland.

This skill is for end-user customization on installed systems.
It is not for contributing to Omarchy source code.

## When This Skill MUST Be Used

**ALWAYS invoke this skill for end-user requests involving ANY of these:**

- Editing ANY file in `~/.config/hypr/` (window rules, animations, keybindings, monitors, etc.)
- Editing ANY file in `~/.config/waybar/`, `~/.config/walker/`, `~/.config/mako/`
- Editing terminal configs (alacritty, kitty, ghostty)
- Editing ANY file in `~/.config/theme/`
- Window behavior, animations, opacity, blur, gaps, borders
- Layer rules, workspace settings, display/monitor configuration
- Themes, wallpapers, fonts, appearance changes
- User-facing `arch-*` commands (`arch-theme-*`, `nix-refresh-*`, `nix-restart-*`, etc.)
- Screenshots, screen recording, night light, idle behavior, lock screen

**If you're about to edit a config file in ~/.config/ on this system, STOP and use this skill first.**

**Do NOT use this skill for Omarchy development tasks** (editing files in `~/.local/share/arch/`, creating migrations, or running `arch-dev-*` workflows).

## Critical Safety Rules

**For end-user customization tasks, NEVER modify anything in `~/.local/share/arch/`** - but READING is safe and encouraged.

This directory contains Omarchy's source files managed by git. Any changes will be:
- Lost on next `nix-update`
- Cause conflicts with upstream
- Break the system's update mechanism

```
~/.local/share/arch/     # READ-ONLY - NEVER EDIT (reading is OK)
├── bin/                    # Source scripts (symlinked to PATH)
├── config/                 # Default config templates
├── themes/                 # Stock themes
├── default/                # System defaults
├── migrations/             # Update migrations
└── install/                # Installation scripts
```

**Reading `~/.local/share/arch/` is SAFE and useful** - do it freely to:
- Understand how arch commands work: `cat $(which nix-theme-set)`
- See default configs before customizing: `cat ~/.local/share/arch/config/waybar/config.jsonc`
- Check stock theme files to copy for customization
- Reference default hyprland settings: `cat ~/.config/default/hypr/*`

**Always use these safe locations instead:**
- `~/.config/` - User configuration (safe to edit)
- `~/.config/theme/themes/<custom-name>/` - Custom themes (must be real directories)
- `~/.config/theme/hooks/` - Custom automation hooks

If the request is to develop Omarchy itself, this skill is out of scope. Follow repository development instructions instead of this skill.

## System Architecture

Omarchy is built on:

| Component | Purpose | Config Location |
|-----------|---------|-----------------|
| **Arch Linux** | Base OS | `/etc/`, `~/.config/` |
| **Hyprland** | Wayland compositor/WM | `~/.config/hypr/` |
| **Waybar** | Status bar | `~/.config/waybar/` |
| **Walker** | App launcher | `~/.config/walker/` |
| **Alacritty/Kitty/Ghostty** | Terminals | `~/.config/<terminal>/` |
| **Mako** | Notifications | `~/.config/mako/` |
| **SwayOSD** | On-screen display | `~/.config/swayosd/` |

## Command Discovery

Omarchy provides ~145 commands following `arch-<category>-<action>` pattern.

```bash
# List all arch commands
compgen -c | grep -E '^arch-' | sort -u

# Find commands by category
compgen -c | grep -E '^arch-theme'
compgen -c | grep -E '^arch-restart'

# Read a command's source to understand it
cat $(which nix-theme-set)
```

### Command Categories

| Prefix | Purpose | Example |
|--------|---------|---------|
| `nix-refresh-*` | Reset config to defaults (backs up first) | `nix-refresh-waybar` |
| `nix-restart-*` | Restart a service/app | `nix-restart-waybar` |
| `nix-toggle-*` | Toggle feature on/off | `nix-toggle-nightlight` |
| `arch-theme-*` | Theme management | `nix-theme-set <name>` |
| `arch-install-*` | Install optional software | `arch-install-docker-dbs` |
| `nix-launch-*` | Launch apps | `nix-launch-browser` |
| `nix-cmd-*` | System commands | `nix-cmd-screenshot` |
| `arch-pkg-*` | Package management | `arch-pkg-install <pkg>` |
| `arch-setup-*` | Initial setup tasks | `arch-setup-fingerprint` |
| `nix-update-*` | System updates | `nix-update` |

## Configuration Locations

### Hyprland (Window Manager)

```
~/.config/hypr/
├── hyprland.conf      # Main config (sources others)
├── bindings.conf      # Keybindings
├── monitors.conf      # Display configuration
├── input.conf         # Keyboard/mouse settings
├── looknfeel.conf     # Appearance (gaps, borders, animations)
├── envs.conf          # Environment variables
├── autostart.conf     # Startup applications
├── hypridle.conf      # Idle behavior (screen off, lock, suspend)
├── hyprlock.conf      # Lock screen appearance
└── hyprsunset.conf    # Night light / blue light filter
```

**Key behaviors:**
- Hyprland auto-reloads on config save (no restart needed for most changes)
- Use `hyprctl reload` to force reload
- Use `nix-refresh-hyprland` to reset to defaults

### Waybar (Status Bar)

```
~/.config/waybar/
├── config.jsonc       # Bar layout and modules (JSONC format)
└── style.css          # Styling
```

**Waybar does NOT auto-reload.** You MUST run `nix-restart-waybar` after any config changes.

**Commands:** `nix-restart-waybar`, `nix-refresh-waybar`, `nix-toggle-waybar`

### Terminals

```
~/.config/alacritty/alacritty.toml
~/.config/kitty/kitty.conf
~/.config/ghostty/config
```

**Command:** `nix-restart-terminal`

### Other Configs

| App | Location |
|-----|----------|
| btop | `~/.config/btop/btop.conf` |
| fastfetch | `~/.config/fastfetch/config.jsonc` |
| lazygit | `~/.config/lazygit/config.yml` |
| starship | `~/.config/starship.toml` |
| git | `~/.config/git/config` |
| walker | `~/.config/walker/config.toml` |

## Safe Customization Patterns

### Pattern 1: Edit User Config Directly

For simple changes, edit files in `~/.config/`:

```bash
# 1. Read current config
cat ~/.config/hypr/bindings.conf

# 2. Backup before changes
cp ~/.config/hypr/bindings.conf ~/.config/hypr/bindings.conf.bak.$(date +%s)

# 3. Make changes with Edit tool

# 4. Apply changes
# - Hyprland: auto-reloads on save (no restart needed)
# - Waybar: MUST restart with nix-restart-waybar
# - Walker: MUST restart with nix-restart-walker
# - Terminals: MUST restart with nix-restart-terminal
```

### Pattern 2: Make a new theme

1. Create a directory under ~/.config/theme/themes.
2. See how an existing theme is done via ~/.local/share/arch/themes/catppuccin.
3. Download a matching background (or several) from the internet and put them in ~/.config/theme/themes/[name-of-new-theme]
4. When done with the theme, run nix-theme-set "Name of new theme"

### Pattern 3: Use Hooks for Automation

Create scripts in `~/.config/theme/hooks/` to run automatically on events:

```bash
# Available hooks (see samples in ~/.config/theme/hooks/):
~/.config/theme/hooks/
├── theme-set        # Runs after theme change (receives theme name as $1)
├── font-set         # Runs after font change
└── post-update      # Runs after nix-update
```

Example hook (`~/.config/theme/hooks/theme-set`):
```bash
#!/bin/bash
THEME_NAME=$1
echo "Theme changed to: $THEME_NAME"
# Add custom actions here
```

### Pattern 4: Reset to Defaults -- ALWAYS SEEK USER CONFIRMATION BEFORE RUNNING

When customizations go wrong:

```bash
# Reset specific config (creates backup automatically)
nix-refresh-waybar
nix-refresh-hyprland

# The refresh command:
# 1. Backs up current config with timestamp
# 2. Copies default from ~/.local/share/arch/config/
# 3. Restarts the component
```

## Common Tasks

### Themes

```bash
arch-theme-list              # Show available themes
arch-theme-current           # Show current theme
nix-theme-set <name>        # Apply theme (use "Tokyo Night" not "tokyo-night")
arch-theme-next              # Cycle to next theme
nix-theme-bg-next           # Cycle wallpaper
arch-theme-install <url>     # Install from git repo
```

### Keybindings

Edit `~/.config/hypr/bindings.conf`. Format:
```
bind = SUPER, Return, exec, xdg-terminal-exec
bind = SUPER, Q, killactive
bind = SUPER SHIFT, E, exit
```

View current bindings: `nix-menu-keybindings --print`

**IMPORTANT: When re-binding an existing key:**

1. First check existing bindings: `nix-menu-keybindings --print`
2. If the key is already bound, you MUST add an `unbind` directive BEFORE your new `bind`
3. Inform the user what the key was previously bound to

Example - rebinding SUPER+F (which is bound to fullscreen by default):
```
# Unbind existing SUPER+F (was: fullscreen)
unbind = SUPER, F
# New binding for file manager
bind = SUPER, F, exec, nautilus
```

Always tell the user: "Note: SUPER+F was previously bound to fullscreen. I've added an unbind directive to override it."

### Display/Monitors

Edit `~/.config/hypr/monitors.conf`. Format:
```
monitor = eDP-1, 1920x1080@60, 0x0, 1
monitor = HDMI-A-1, 2560x1440@144, 1920x0, 1
```

List monitors: `hyprctl monitors`

### Window Rules

**CRITICAL: Hyprland window rules syntax changes frequently between versions.**

Before writing ANY window rules, you MUST fetch the current documentation from the official Hyprland wiki:
- https://github.com/hyprwm/hyprland-wiki/blob/main/content/Configuring/Window-Rules.md

DO NOT rely on cached or memorized window rule syntax. The format has changed multiple times and using outdated syntax will cause errors or unexpected behavior.

Window rules go in `~/.config/hypr/hyprland.conf` or a sourced file. Always verify the current syntax from the wiki first.

### Fonts

```bash
arch-font-list               # Available fonts
arch-font-current            # Current font
arch-font-set <name>         # Change font
```

### System

```bash
nix-update                  # Full system update
nix-version                 # Show Omarchy version
arch-debug --no-sudo --print # Debug info (ALWAYS use these flags)
nix-lock-screen             # Lock screen
arch-system-shutdown         # Shutdown
arch-system-reboot           # Reboot
```

**IMPORTANT:** Always run `arch-debug` with `--no-sudo --print` flags to avoid interactive sudo prompts that will hang the terminal.

## Troubleshooting

```bash
# Get debug information (ALWAYS use these flags to avoid interactive prompts)
arch-debug --no-sudo --print

# Upload logs for support
arch-upload-log

# Reset specific config to defaults
nix-refresh-<app>

# Refresh specific config file
# config-file path is relative to ~/.config/
# eg. nix-refresh-config hypr/hyprlock.conf will refresh ~/.config/hypr/hyprlock.conf
nix-refresh-config <config-file>

# Full reinstall of configs (nuclear option)
arch-reinstall
```

## Decision Framework

When user requests system changes:

1. **Is it a stock arch command?** Use it directly
2. **Is it a config edit?** Edit in `~/.config/`, never `~/.local/share/arch/`
3. **Is it a theme customization?** Create a NEW custom theme directory
4. **Is it automation?** Use hooks in `~/.config/theme/hooks/`
5. **Is it a package install?** Use `arch-pkg-add` (or `arch-pkg-aur-add` for AUR-only packages)
6. **Unsure if command exists?** Search with `compgen -c | grep arch`

## Out of Scope

This skill intentionally does not cover Omarchy source development. Do not use this skill for:
- Editing files in `~/.local/share/arch/` (`bin/`, `config/`, `default/`, `themes/`, `migrations/`, etc.)
- Creating or editing migrations
- Running `arch-dev-*` commands

## Example Requests

- "Change my theme to catppuccin" -> `nix-theme-set catppuccin`
- "Add a keybinding for Super+E to open file manager" -> Check existing bindings first, add `unbind` if needed, then add `bind` in `~/.config/hypr/bindings.conf`
- "Configure my external monitor" -> Edit `~/.config/hypr/monitors.conf`
- "Make the window gaps smaller" -> Edit `~/.config/hypr/looknfeel.conf`
- "Set up night light to turn on at sunset" -> `nix-toggle-nightlight` or edit `~/.config/hypr/hyprsunset.conf`
- "Customize the catppuccin theme colors" -> Create `~/.config/theme/themes/catppuccin-custom/` by copying from stock, then edit
- "Run a script every time I change themes" -> Create `~/.config/theme/hooks/theme-set`
- "Reset waybar to defaults" -> `nix-refresh-waybar`
