local activeBorderColor = "rgb({{ accent_strip }})"

hl.config({
    general = {
        col = {
            active_border = activeBorderColor,
        },
    },

    group = {
        col = {
            border_active = activeBorderColor,
        },
    },
})
