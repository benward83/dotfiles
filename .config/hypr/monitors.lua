-- Ported from .config/hypr/monitors.conf (Omarchy 3.x)
-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

-- Keep these two variable names. omarchy-hyprland-monitor-clamshell and
-- omarchy-hyprland-monitor-scaling parse and rewrite this file by name.
local omarchy_gdk_scale = 1
local omarchy_monitor_scale = "auto"

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))

-- Explicit positioning to prevent wraparound (left to right: DP-1, DP-2, DP-3)
hl.monitor({ output = "DP-1", mode = "preferred", position = "0x0", scale = omarchy_monitor_scale })
hl.monitor({ output = "DP-2", mode = "preferred", position = "1920x0", scale = omarchy_monitor_scale })
hl.monitor({ output = "DP-3", mode = "preferred", position = "3840x0", scale = omarchy_monitor_scale })
