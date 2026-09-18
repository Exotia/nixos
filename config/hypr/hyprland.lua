-- Hyprland entry point. Only require() lines live here.
-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/

-- Look, input, monitors, environment
require("envs")
require("monitors")
require("input")
require("looknfeel")
require("theme")

-- Window rules (general rules + one file per app in ./rules/)
require("windows")

-- Keybindings, one file per modifier group
--   apps.lua      SUPER + key          launch applications and web apps
--   windows.lua   SUPER + SHIFT / ALT  focus, move, resize, workspaces, tiling
--   system.lua    SUPER + CTRL         lock, idle, menus, panels, notifications
--   clipboard.lua SUPER + C/V/X        copy, paste, cut
--   media.lua     XF86 keys            volume, brightness, playback
require("bindings.apps")
require("bindings.windows")
require("bindings.system")
require("bindings.clipboard")
require("bindings.media")

-- Programs started with the session
require("autostart")
