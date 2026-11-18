-- ═══════════════════════════════════════════
--           KITTY FROSTED GLASS
-- ═══════════════════════════════════════════

-- Global blur engine
hl.config({
    decoration = {
        blur = {
            enabled = true,
            size = 8,
            passes = 3,

            ignore_opacity = false,
            new_optimizations = true,

            brightness = 0.90,
            contrast = 1.05,
            vibrancy = 0.25,
            vibrancy_darkness = 0.5,
        },
    },
})


-- Kitty frosted glass treatment
hl.window_rule({
    name = "kitty-glass",
    match = {
        class = "^kitty$",
    },

    rounding = 16,
    border_size = 1,
    border_color = "rgb(A5B4FC) rgb(45435F)",
               opacity = "1.0 override 1.0 override 1.0 override",
})
