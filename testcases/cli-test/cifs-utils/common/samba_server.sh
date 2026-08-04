#!/usr/bin/bash

# Common Samba server setup/cleanup functions for cifs-utils tests
# Source this file in test scripts: source "$(dirname "$0")/common/samba_server.sh"

# Start a local Samba server with a guest-accessible share and mount it
# Parameters:
#   $1 - config file path
#   $2 - share directory path
#   $3 - mount point path
#   $4 - additional smb.conf entries (optional)
function samba_start() {
    local config="$1"
    local share="$2"
    local mount="$3"
    local extra_config="${4:-}"

    if [ -z "$config" ] || [ -z "$share" ] || [ -z "$mount" ]; then
        echo "ERROR: samba_start requires config, share, and mount parameters"
        return 1
    fi

    # Cleanup any leftover processes from previous runs
    samba_stop "$config" "$mount"

    mkdir -p "$share"
    mkdir -p "$mount"

    cat > "$config" << EOF
[global]
    workgroup = WORKGROUP
    security = user
    map to guest = Bad User
    ${extra_config}

[testshare]
    path = ${share}
    guest ok = yes
    read only = no
    browseable = yes
    force user = root
    force group = root
EOF

    smbd -s "$config" > /dev/null 2>&1
    sleep 2

    if ! ss -tlnp 2>/dev/null | grep -q :445; then
        echo "ERROR: smbd failed to start on port 445"
        return 1
    fi

    mount.cifs "//127.0.0.1/testshare" "$mount" -o guest,vers=3.0 > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "ERROR: Failed to mount CIFS share"
        return 1
    fi

    echo "Samba server started: config=$config share=$share mount=$mount"
    return 0
}

# Stop Samba server and cleanup
# Parameters:
#   $1 - config file path (optional)
#   $2 - mount point path (optional)
function samba_stop() {
    local config="${1:-}"
    local mount="${2:-}"

    if [ -n "$mount" ] && mountpoint -q "$mount" 2>/dev/null; then
        umount -l "$mount" 2>/dev/null
    fi

    if [ -n "$config" ] && [ -f "$config" ]; then
        pkill -9 -f "smbd.*$config" 2>/dev/null
        rm -f "$config"
    fi

    sleep 1

    if [ -n "$mount" ] && [ -d "$mount" ]; then
        rm -rf "$mount"
    fi

    echo "Samba server stopped and cleaned up"
}
