-- See https://wiki.hypr.land/Configuring/Monitors/
-- List current monitors and resolutions possible: hyprctl monitors
-- Format: hl.monitor({ output = [port], mode = resolution, position = position, scale = scale })

-- MacBook Air M2 internal display (2560x1600 @ 60Hz, 13.6").
-- Hyprland's auto default is scale 2 (1280x800 logical). 1.6 gives
-- 1600x1000 logical, which is the agreed compromise; change this one number
-- if you want bigger/smaller UI.
hl.monitor({ output = "eDP-1", mode = "2560x1600@60", position = "0x0", scale = 1.6 })

-- Anything plugged in later: preferred mode, placed to the right, scale 1
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
