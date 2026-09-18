-- SUPER + key: launch applications and web apps.
-- Define each command once as a local, then bind it. Add a new app = one local + one bind.

local home        = os.getenv("HOME")
local scripts     = home .. "/nixos-dotfiles/config/scripts"
local terminal    = 'uwsm-app -- xdg-terminal-exec --dir="$(nix-cmd-terminal-cwd)"'
local browser     = "uwsm-app -- brave"
local fileManager = "uwsm-app -- pcmanfm --new-window"
local webapp      = home .. "/.config/scripts/launch-webapp"
local webappFlags = "--ozone-platform-hint=auto --force-dark-mode --enable-features=WebUIDarkMode,DefaultPascalCaseDynamicRefColors --dark-mode"

-- Menus
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd(scripts .. "/nix-menu-apps-favorites"))
hl.bind("SUPER + A",     hl.dsp.exec_cmd(scripts .. "/nix-app-launcher.py"))

-- Core apps
hl.bind("SUPER + RETURN",         hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + SHIFT + RETURN", hl.dsp.exec_cmd(browser))
hl.bind("SUPER + ALT + RETURN",   hl.dsp.exec_cmd(browser .. " --incognito"))
hl.bind("SUPER + F",              hl.dsp.exec_cmd(fileManager))
hl.bind("SUPER + ALT + F",        hl.dsp.exec_cmd(fileManager .. ' "$(nix-cmd-terminal-cwd)"'))
hl.bind("SUPER + S",              hl.dsp.exec_cmd("nix-launch-or-focus spotify"))
hl.bind("SUPER + O",              hl.dsp.exec_cmd('nix-launch-or-focus ^obsidian$ "uwsm-app -- obsidian -disable-gpu --enable-wayland-ime"'))
hl.bind("SUPER + G",              hl.dsp.exec_cmd(browser .. " gemini.google.com"))

-- Web apps
hl.bind("SUPER + Y", hl.dsp.exec_cmd(webapp .. " https://youtube.com " .. webappFlags))
hl.bind("SUPER + T", hl.dsp.exec_cmd(webapp .. " https://twitch.com " .. webappFlags))
