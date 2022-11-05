# exports for Java on wayland
test -z "$WAYLAND_DISPLAY" || export _JAVA_AWT_WM_NONREPARENTING=1
