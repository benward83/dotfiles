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

-- Keep VS Code on the middle monitor. Direct translation of the 3.x
-- `windowrule = monitor DP-2, match:class ^(code)$`, which works today.
--
-- Not attested in Quattro's own config, and the Hyprland Lua stub does not list
-- `monitor` under HL.WindowRuleSpec — but that stub lists no rule properties at
-- all, not even ones Hyprland's own hyprland.lua uses, so it settles nothing.
-- Try this first; it is one reload to find out.
o.window("^(code)$", { monitor = "DP-2" })

-- Fallback if the above errors. `monitor` is attested on HL.WorkspaceRuleSpec,
-- so pin a workspace to the monitor and send VS Code to it. The cost is that
-- everything else on that workspace gets pinned to DP-2 too, which the rule
-- above does not do.
-- hl.workspace_rule({ workspace = "3", monitor = "DP-2" })
-- o.window("^(code)$", { workspace = "3" })
