-- Ported from .config/hypr/input.conf (Omarchy 3.x)
-- See https://wiki.hypr.land/Configuring/Basics/Variables/#input

hl.config({
  input = {
    -- us/es layouts, switched with Left Alt + Right Alt
    kb_layout = "us,es",
    kb_options = "compose:caps,grp:alts_toggle",

    repeat_rate = 40,
    repeat_delay = 600,

    numlock_by_default = true,

    touchpad = {
      natural_scroll = true,
      scroll_factor = 0.4,
    },
  },
})

-- Scroll nicely in the terminal
o.window("(Alacritty|kitty|foot)", { scroll_touchpad = 1.5 })
o.window("com.mitchellh.ghostty", { scroll_touchpad = 0.2 })
