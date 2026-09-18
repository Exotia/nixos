-- Define terminal tag to style them uniformly
hl.window_rule({ match = { class = "(Alacritty|kitty|com.mitchellh.ghostty)" }, tag = "+terminal" })
hl.window_rule({ match = { tag = "terminal" }, tag = "-default-opacity" })
hl.window_rule({ match = { tag = "terminal" }, opacity = "0.97 0.9" })

-- Scroll nicely in the terminal
hl.window_rule({ match = { class = "(Alacritty|kitty)" }, scroll_touchpad = 1.5 })
hl.window_rule({ match = { class = "com.mitchellh.ghostty" }, scroll_touchpad = 0.2 })
