-- Ported from .config/hypr/autostart.conf (Omarchy 3.x)

-- Desktop speakers for output, Scarlett 6i6 for mic input.
-- Quattro has omarchy-audio-output-set-default / omarchy-audio-input-set-default,
-- which drive the same wireplumber state and survive device renumbering better.
-- Try those first; these raw pactl calls are the like-for-like fallback.
o.exec_on_start("pactl set-default-sink alsa_output.pci-0000_00_1f.3.analog-stereo")
o.exec_on_start("pactl set-default-source alsa_input.usb-Focusrite_Scarlett_6i6_USB_100137E9-00.analog-surround-21")
