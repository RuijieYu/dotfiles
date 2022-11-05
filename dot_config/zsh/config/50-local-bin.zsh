# add a few quasi-standard local executable directories
for p in "$HOME/.local/bin"; do
    prepend_path PATH "$p"
done
