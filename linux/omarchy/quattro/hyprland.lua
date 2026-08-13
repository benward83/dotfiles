-- Ported from .config/hypr/hyprland.conf (Omarchy 3.x)
-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Omarchy's bootstrap keeps path setup out of this user config.
dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

-- Drop Omarchy's bindings for its own preinstalled apps and web apps, keeping
-- the core window-manager ones. bindings.lua owns that space instead — without
-- this, every override there would stack on top of a default rather than
-- replace it.
omarchy_preinstalled_bindings = false

-- Load Omarchy defaults.
require("default.hypr.omarchy")

-- Personal overrides, loaded after the defaults.
require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

-- Toggle config flags dynamically.
require("default.hypr.toggles")

-- Keep VS Code on the middle monitor.
-- UNVERIFIED: no `monitor` window rule is used anywhere in the Quattro
-- defaults. This is the obvious analogue of the 3.x
-- `windowrule = monitor DP-2, match:class ^(code)$` but needs checking against
-- the Hyprland wiki on the day — window rule syntax moves between versions.
o.window("^(code)$", { monitor = "DP-2" })
