#!/usr/bin/bash

# Common Samba server setup/cleanup functions for cifs-utils tests
# Source this file in test scripts: source "$(dirname "$0")/common/samba_server.sh"

# Start a local Samba server with user authentication and mount it
# Parameters:
#   $1 - config file path
#   $2 - share directory path
#   $3 - mount point path
#   $4 - additional smb.conf entries (optional)
function samba_start() {
    config="$1"
    share="$2"
    mount="$3"
    extra_config="${4:-}"

    if [ -z "$config" ] || [ -z "$share" ] || [ -z "$mount" ]; then
        echo "ERROR: samba_start requires config, share, and mount parameters"
        return 1
    fi

    # Cleanup any leftover processes from previous runs
    samba_stop "$config" "$mount"
    pkill -9 smbd 2>/dev/null || true
    rm -f /run/smbd.pid 2>/dev/null

    mkdir -p "$share"
    # Force cleanup stale mount point before mkdir
    umount -lf "$mount" 2>/dev/null
    mkdir -p "$mount" 2>/dev/null || { rmdir "$mount" 2>/dev/null; mkdir -p "$mount"; }

    # Create Samba user with NODE1_PASSWORD to avoid interactive password prompt
    (echo "${NODE1_PASSWORD}"; echo "${NODE1_PASSWORD}") | smbpasswd -a root -s > /dev/null 2>&1
    smbpasswd -e root > /dev/null 2>&1

    cat > "$config" << EOF
[global]
    workgroup = WORKGROUP
    security = user
    ${extra_config}

[testshare]
    path = ${share}
    valid users = root
    read only = no
    browseable = yes
    force user = root
    force group = root
EOF

    smbd -s "$config" > /dev/null 2>&1
    SLEEP_WAIT 2

    if ! ss -tlnp 2>/dev/null | grep -qE ':445[[:space:]]|:445$'; then
        echo "ERROR: smbd failed to start on port 445"
        return 1
    fi

    mount.cifs "//127.0.0.1/testshare" "$mount" -o "username=root,password=${NODE1_PASSWORD},vers=2.0" > /dev/null 2>&1 || {
        echo "ERROR: Failed to mount CIFS share"
        return 1
    }

    echo "Samba server started: config=$config share=$share mount=$mount"
    return 0
}

# Stop Samba server and cleanup
# Parameters:
#   $1 - config file path (optional)
#   $2 - mount point path (optional)
function samba_stop() {
    config="${1:-}"
    mount="${2:-}"

    if [ -n "$mount" ] && mountpoint -q "$mount" 2>/dev/null; then
        umount -l "$mount" 2>/dev/null
    fi

    if [ -n "$config" ] && [ -f "$config" ]; then
        pkill -9 -f "smbd.*$config" 2>/dev/null
        rm -f "$config"
    fi

    SLEEP_WAIT 1

    if [ -n "$mount" ] && [ -d "$mount" ]; then
        rm -rf "$mount"
    fi

    echo "Samba server stopped and cleaned up"
}
