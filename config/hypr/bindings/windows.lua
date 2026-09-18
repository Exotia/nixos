-- SUPER + SHIFT / ALT: close, focus, move, resize, workspaces, tiling, groups.

-- Close windows
hl.bind("SUPER + W",          hl.dsp.window.close())
hl.bind("CTRL + ALT + DELETE", hl.dsp.exec_cmd("nix-hyprland-window-close-all"))

-- Control tiling (SUPER + SHIFT)
hl.bind("SUPER + SHIFT + J",         hl.dsp.layout("togglesplit"))
hl.bind("SUPER + SHIFT + T",         hl.dsp.window.float())
hl.bind("SUPER + SHIFT + F",         hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind("SUPER + CTRL + SHIFT + F",  hl.dsp.window.fullscreen({ mode = "fullscreen" })) -- was `fullscreen, 2`, which Hyprland now treats the same as 0
hl.bind("SUPER + ALT + SHIFT + F",   hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind("SUPER + SHIFT + O",         hl.dsp.exec_cmd("nix-hyprland-window-pop"))
hl.bind("SUPER + SHIFT + L",         hl.dsp.exec_cmd("nix-hyprland-workspace-layout-toggle"))

-- Move focus with SUPER + arrow keys
hl.bind("SUPER + LEFT",  hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + RIGHT", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + UP",    hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + DOWN",  hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with SUPER + [1-9; 0]
-- SUPER + 0 opens the theme menu (bindings/system.lua), so workspace 10 has no switch key
for i = 1, 9 do
    hl.bind("SUPER + code:" .. (9 + i), hl.dsp.focus({ workspace = i }))
end

-- Move active window to a workspace with SUPER + SHIFT + [1-9; 0]
for i = 1, 10 do
    hl.bind("SUPER + SHIFT + code:" .. (9 + i), hl.dsp.window.move({ workspace = i }))
end

-- Cycle through applications on active workspace
hl.bind("ALT + TAB", function()
    hl.dispatch(hl.dsp.window.cycle_next())
    hl.dispatch(hl.dsp.window.bring_to_top())
end)

-- Resize active window (SUPER + ALT + arrow keys)
hl.bind("SUPER + ALT + LEFT",  hl.dsp.window.resize({ x = -100, y = 0,    relative = true }), { repeating = true })
hl.bind("SUPER + ALT + RIGHT", hl.dsp.window.resize({ x = 100,  y = 0,    relative = true }), { repeating = true })
hl.bind("SUPER + ALT + UP",    hl.dsp.window.resize({ x = 0,    y = -100, relative = true }), { repeating = true })
hl.bind("SUPER + ALT + DOWN",  hl.dsp.window.resize({ x = 0,    y = 100,  relative = true }), { repeating = true })

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Toggle groups
hl.bind("SUPER + SHIFT + G", hl.dsp.group.toggle())
hl.bind("SUPER + ALT + G",   hl.dsp.window.move({ out_of_group = true }))
