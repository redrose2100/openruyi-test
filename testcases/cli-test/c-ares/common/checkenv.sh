#!/bin/bash

# Check c-ares version >= 1.34.8; otherwise skip (c-ares-utils unavailable).
check_c_ares_version() {
    installed_version=$(rpm -q c-ares --qf '%{VERSION}' 2>/dev/null)
    if [ "$(printf '%s\n%s\n' "${installed_version}" "1.34.8" | sort -V | head -1)" != "1.34.8" ]; then
        echo "c-ares version ${installed_version} < 1.34.8, c-ares-utils unavailable, skipping test"
        exit 255
    fi
}
