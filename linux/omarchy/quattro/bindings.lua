-- Ported from .config/hypr/bindings.conf (Omarchy 3.x)
--
-- This assumes `omarchy_preinstalled_bindings = false` is set in hyprland.lua
-- (see the staged hyprland.lua alongside this file). That switch drops every
-- Omarchy default for preinstalled apps and web apps, which is nearly the whole
-- SUPER+SHIFT+<letter> range, and leaves this file free to own it.
--
-- Without that switch, almost every binding below would DOUBLE UP rather than
-- replace: o.bind on an already-bound key adds a second dispatcher, it does not
-- overwrite. Omarchy relies on that behaviour deliberately elsewhere.
--
-- The four "essential" defaults survive the switch and are still bound:
--   SUPER+RETURN (terminal)   SUPER+SHIFT+RETURN (browser)
--   SUPER+SHIFT+F (files)     SUPER+ALT+SHIFT+F (files, cwd)
--   SUPER+SHIFT+B (browser)   SUPER+SHIFT+ALT+B (browser, private)
--   SUPER+SHIFT+N (editor)
-- Rather than override those, point Omarchy at the right apps:
--   omarchy default terminal ghostty
--   omarchy default editor code
--   omarchy default browser firefox
-- The defaults then do what bindings.conf used to do by hand, and SUPER+RETURN,
-- SUPER+SHIFT+B/ALT+B, SUPER+SHIFT+N and SUPER+ALT+SHIFT+F need nothing here.

-- Applications
o.bind("SUPER + SHIFT + M", "Music", { launch = "spotify --force-device-scale-factor=1.0", focus = "spotify" })
o.bind("SUPER + SHIFT + ALT + M", "Music TUI", { tui = "cliamp", focus = true })
o.bind("SUPER + SHIFT + T", "Telegram", { launch = "Telegram", focus = "org.telegram.desktop" })
o.bind("SUPER + SHIFT + D", "Docker", { tui = "lazydocker" })
o.bind("SUPER + SHIFT + G", "Signal", { launch = "signal-desktop", focus = "signal" })
o.bind("SUPER + SHIFT + S", "Slack", { launch = "slack", focus = "^Slack$" })
o.bind("SUPER + SHIFT + O", "Obsidian", {
  launch = "obsidian --enable-features=UseOzonePlatform --ozone-platform=wayland --disable-gpu-sandbox --enable-wayland-ime",
  focus = "^obsidian$",
})
o.bind("SUPER + SHIFT + ALT + W", "Typora", { launch = "typora" })
o.bind("SUPER + SHIFT + C", "Claude", { launch = "claude-desktop", focus = "claude-desktop" })
o.bind("SUPER + SHIFT + P", "Activity", { tui = "btop" })

-- xkbcommon names this keysym in lower case; "SLASH" does not match.
o.bind("SUPER + SHIFT + slash", "Passwords", { launch = "1password" })

-- Web apps. With focus = true the description doubles as the window match,
-- so "WhatsApp" and "Google Messages" have to stay spelled as they are.
o.bind("SUPER + SHIFT + A", "ChatGPT", { webapp = "https://chatgpt.com" })
o.bind("SUPER + SHIFT + ALT + A", "Grok", { webapp = "https://grok.com" })
o.bind("SUPER + SHIFT + E", "Email", { webapp = "https://app.hey.com" })
o.bind("SUPER + SHIFT + Y", "YouTube", { webapp = "https://youtube.com/" })
o.bind("SUPER + SHIFT + W", "WhatsApp", { webapp = "https://web.whatsapp.com/", focus = true })
o.bind("SUPER + SHIFT + CTRL + G", "Google Messages",
  { webapp = "https://messages.google.com/web/conversations", focus = true })
o.bind("SUPER + SHIFT + X", "X", { webapp = "https://x.com/" })
o.bind("SUPER + SHIFT + ALT + X", "X Post", { webapp = "https://x.com/compose/post" })

o.bind("SUPER + ALT + SHIFT + G", "Ungroup all windows",
  [[hyprctl clients -j | jq -r '.[] | select(.grouped | length > 1) | .address' | while read addr; do hyprctl dispatch focuswindow "address:$addr" && hyprctl dispatch moveoutofgroup; done]])

-- Volume is NOT here on purpose. Quattro binds XF86AudioRaiseVolume /
-- LowerVolume / Mute by default in default/hypr/bindings/media.lua, routed
-- through omarchy-audio-output-volume so the on-screen display fires. The raw
-- wpctl calls from bindings.conf would stack on top and fight it.

-- Screenshots. Mac keyboard has no Print key; mimics macOS Cmd+Shift+3/4/5.
-- SUPER+SHIFT+<num> is taken by workspace moves, so these use SUPER+CTRL.
--
-- These three DO collide. utilities.lua binds SUPER+CTRL+code:10..18 to the bar
-- panels, and that is not gated by omarchy_preinstalled_bindings. It binds by
-- keycode, so unbinding by keysym ("SUPER + CTRL + 3") will not match —
-- keycodes 12, 13, 14 are the physical 3, 4 and 5 keys.
hl.unbind("SUPER + CTRL + code:12")
hl.unbind("SUPER + CTRL + code:13")
hl.unbind("SUPER + CTRL + code:14")

o.bind("SUPER + CTRL + 3", "Screenshot (fullscreen)", "omarchy-capture-screenshot fullscreen")
o.bind("SUPER + CTRL + 4", "Screenshot (region)", "omarchy-capture-screenshot region")
o.bind("SUPER + CTRL + 5", "Screen recording",
  "omarchy-capture-screenrecording --stop-recording || omarchy-menu toggle trigger.capture.screenrecord")
