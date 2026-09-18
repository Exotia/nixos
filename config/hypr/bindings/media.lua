-- Only display the OSD on the currently focused monitor
local osdclient = [[swayosd-client --monitor "$(hyprctl monitors -j | jq -r '.[] | select(.focused == true).name')"]]

-- Laptop multimedia keys for volume and LCD brightness (with OSD)
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd(osdclient .. " --output-volume raise"),       { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd(osdclient .. " --output-volume lower"),       { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd(osdclient .. " --output-volume mute-toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd(osdclient .. " --input-volume mute-toggle"),  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("nix-brightness-display +5%"),                { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("nix-brightness-display 5%-"),                { locked = true, repeating = true })
hl.bind("XF86KbdBrightnessUp",   hl.dsp.exec_cmd("nix-brightness-keyboard up"),                { locked = true, repeating = true })
hl.bind("XF86KbdBrightnessDown", hl.dsp.exec_cmd("nix-brightness-keyboard down"),              { locked = true, repeating = true })
hl.bind("XF86KbdLightOnOff",     hl.dsp.exec_cmd("nix-brightness-keyboard cycle"),             { locked = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd(osdclient .. " --playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(osdclient .. " --playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd(osdclient .. " --playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd(osdclient .. " --playerctl previous"),   { locked = true })
