-- SUPER + CTRL: system toggles, menus, panels, notifications, power.

local scripts = os.getenv("HOME") .. "/nixos-dotfiles/config/scripts"

-- Menus
hl.bind("SUPER + code:19",      hl.dsp.exec_cmd(scripts .. "/nix-menu-theming")) -- SUPER + 0: theme, background, power
hl.bind("SUPER + CTRL + SPACE", hl.dsp.exec_cmd(scripts .. "/nix-menu-keybindings"))

-- Toggles
hl.bind("SUPER + CTRL + I",                 hl.dsp.exec_cmd("nix-toggle-idle"))
hl.bind("SUPER + CTRL + L",                 hl.dsp.exec_cmd("nix-lock-screen"))
hl.bind("SUPER + CTRL + COMMA",             hl.dsp.exec_cmd("nix-toggle-notification-silencing"))
hl.bind("SUPER + SHIFT + SPACE",            hl.dsp.exec_cmd("nix-toggle-waybar"))
hl.bind("SUPER + CTRL + SHIFT + BACKSPACE", hl.dsp.exec_cmd("nix-hyprland-window-gaps-toggle"))

-- Captures
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("nix-cmd-screenshot"))

-- Control panels
hl.bind("SUPER + CTRL + A", hl.dsp.exec_cmd("alacritty -e pulsemixer"))
hl.bind("SUPER + CTRL + W", hl.dsp.exec_cmd("alacritty -e nmtui"))
hl.bind("SUPER + CTRL + T", hl.dsp.exec_cmd("alacritty --class TUI.float -e btop"))

-- Notifications
hl.bind("SUPER + COMMA",         hl.dsp.exec_cmd("makoctl dismiss"))
hl.bind("SUPER + SHIFT + COMMA", hl.dsp.exec_cmd("makoctl dismiss --all"))

-- Power
hl.bind("SUPER + ESCAPE", hl.dsp.exec_cmd("systemctl poweroff"))
