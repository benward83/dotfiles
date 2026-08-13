-- Ported from .config/hypr/bindings.conf (Omarchy 3.x)
--
-- This file is required AFTER Omarchy's defaults, so any key here that Omarchy
-- already binds must be hl.unbind()'d first. Before installing this, list what
-- is actually bound:
--
--   omarchy menu keybindings --print
--
-- then add hl.unbind("...") above each collision.
--
-- SUPER+RETURN is deliberately absent. It is an Omarchy default that now routes
-- through xdg-terminal-exec; set the terminal with `omarchy default terminal
-- ghostty` instead of rebinding the key. Same for the editor and browser:
--   omarchy default editor code
--   omarchy default browser firefox

o.bind("SUPER + ALT + RETURN", "Tmux",
  [[uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)" tmux new]])

-- Applications
o.bind("SUPER + SHIFT + F", "File manager", { launch = "nautilus --new-window" })
o.bind("SUPER + ALT + SHIFT + F", "File manager (cwd)",
  [[uwsm-app -- nautilus --new-window "$(omarchy-cmd-terminal-cwd)"]])
o.bind("SUPER + SHIFT + B", "Browser", { launch = "firefox" })
o.bind("SUPER + SHIFT + ALT + B", "Browser (private)", { launch = "firefox --private" })
o.bind("SUPER + SHIFT + M", "Music", { launch = "spotify --force-device-scale-factor=1.0", focus = "spotify" })
o.bind("SUPER + SHIFT + ALT + M", "Music TUI", { tui = "cliamp", focus = true })
o.bind("SUPER + SHIFT + N", "Editor", { omarchy = "editor" })
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

-- xkbcommon names this keysym "slash" in lower case; "SLASH" does not match.
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
o.bind("SUPER + SHIFT + P", "Activity", { tui = "btop" })

o.bind("SUPER + ALT + SHIFT + G", "Ungroup all windows",
  [[hyprctl clients -j | jq -r '.[] | select(.grouped | length > 1) | .address' | while read addr; do hyprctl dispatch focuswindow "address:$addr" && hyprctl dispatch moveoutofgroup; done]])

-- Volume. Quattro binds these by default in default/hypr/bindings/media.lua and
-- routes through omarchy-audio-output-volume so the OSD fires — the raw wpctl
-- calls from 3.x are almost certainly redundant now. Check the defaults first
-- and delete this block if they are already there.
o.bind("XF86AudioRaiseVolume", "Volume up", "omarchy-audio-output-volume raise", { locked = true, repeating = true })
o.bind("XF86AudioLowerVolume", "Volume down", "omarchy-audio-output-volume lower", { locked = true, repeating = true })
o.bind("XF86AudioMute", "Mute", "omarchy-audio-output-volume mute-toggle", { locked = true })

-- Screenshots. Mac keyboard has no Print key; mimics macOS Cmd+Shift+3/4/5.
-- SUPER+SHIFT+<num> is taken by workspace moves, so these use SUPER+CTRL.
-- TODO verify args on the day — the 3.x omarchy-cmd-screenshot fullscreen|region
-- became separate binaries and the argument forms are unconfirmed.
o.bind("SUPER + CTRL + 3", "Screenshot (fullscreen)", "omarchy-capture-screenshot")
o.bind("SUPER + CTRL + 4", "Screenshot (region)", "omarchy-capture-region")
o.bind("SUPER + CTRL + 5", "Screen recording", "omarchy-capture-screenrecording")
