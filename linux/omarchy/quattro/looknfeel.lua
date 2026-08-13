-- Ported from .config/hypr/looknfeel.conf (Omarchy 3.x)

-- More transparency than the Omarchy default when toggled.
-- The default rule lives in default/hypr/windows.lua and is applied against
-- the "default-opacity" tag, so match the same way rather than on class ".*".
o.window({ tag = "default-opacity" }, { opacity = "0.97 0.9" })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
hl.config({
  decoration = {
    rounding = 20,
  },
})
