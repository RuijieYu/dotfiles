# when wayland display is available, let firefox use it
test -z "$WAYLAND_DISPLAY" || export MOZ_ENABLE_WAYLAND=1
