# some potentially-helpful commands for btrfs management
btrfs_opts=rw,noatime,compress=zstd,discard=async,space_cache=v2,autodefrag,subvolid=5
alias btrfs-mount="mount -o $btrfs_opts"
alias btrfs-sm="systemd-mount -o $btrfs_opts"
