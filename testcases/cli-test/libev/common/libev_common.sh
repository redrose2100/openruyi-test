#!/usr/bin/bash
# Usage: libev_compile <src_path> <bin_path>
function libev_compile() {
    local src=$1
    local bin=$2
    gcc "${src}" -o "${bin}" -lev
    CHECK_RESULT $? 0 0 "Failed to compile ${src}"
}

# Usage: libev_run <bin_path> <out_path>
function libev_run() {
    local bin=$1
    local out=$2
    "${bin}" > "${out}"
}

