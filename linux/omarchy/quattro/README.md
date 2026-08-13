# Omarchy Quattro staging

Hand-ported Hyprland config for Omarchy 4 (Quattro), written 2026-08-13 against
the `quattro` branch while it was still `4.0.0.alpha`.

**Nothing here is live.** These files are not sourced, required, or symlinked
anywhere. They sit here so the port is already done on upgrade day.

Quattro replaces Hyprland's `.conf` files with Lua and ships no converter — the
upgrade leaves the old `.conf` files in place, unread. These are the
translations of the six files in `.dotfiles/.config/hypr/` that carry real
customisation.

| File | Replaces | Install to |
| --- | --- | --- |
| `hyprland.lua` | `hyprland.conf` | `~/.config/hypr/hyprland.lua` |
| `bindings.lua` | `bindings.conf` | `~/.config/hypr/bindings.lua` |
| `monitors.lua` | `monitors.conf` | `~/.config/hypr/monitors.lua` |
| `input.lua` | `input.conf` | `~/.config/hypr/input.lua` |
| `looknfeel.lua` | `looknfeel.conf` | `~/.config/hypr/looknfeel.lua` |
| `autostart.lua` | `autostart.conf` | `~/.config/hypr/autostart.lua` |
| `uwsm-env.d-99-ben` | `envs.conf` | `~/.config/uwsm/env.d/99-ben` |

## The one decision baked in

`hyprland.lua` sets `omarchy_preinstalled_bindings = false`.

In Quattro, `o.bind` on a key that is already bound **adds a second dispatcher —
it does not replace the first**. Both fire. Since `bindings.conf` overrides
nearly every `SUPER+SHIFT+<letter>` that Omarchy binds for its own preinstalled
apps, the alternative was an `hl.unbind` before almost every line. Turning the
whole preinstalled set off is one line and does the same job.

The consequence: Omarchy's own web app bindings (Calendar, Google Photos, Google
Maps, Omawrite, its WhatsApp on `SUPER+SHIFT+ALT+G`) are gone. Everything in
`bindings.lua` is what remains. The core window-manager bindings — workspaces,
tiling, menus, capture, panels — are untouched.

No port exists for `hypridle.conf` or `hyprlock.conf` — both packages are
removed in Quattro. Idle timings become two integers in
`~/.config/omarchy/shell.json`, lock screen appearance becomes a `[lock]`
section in the theme. `hyprsunset.conf` and `xdph.conf` stay as `.conf` and are
left alone by the upgrade.

Re-verify against the tagged release before installing any of this. The full
runbook, including pre-flight checks and rollback, is in the Obsidian vault at
`Omarchy/Omarchy Quattro Migration Plan - 2026-08-13.md`.
