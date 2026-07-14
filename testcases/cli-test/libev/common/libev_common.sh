#!/usr/bin/bash
# Common helpers for libev test cases.
# Fixture C sources reside in this common/ directory and are compiled
# directly from their absolute path (no need to copy to the working dir).

# Compile a libev C test program and assert success.
# Usage: libev_compile <src_path> <bin_path>
function libev_compile() {
    local src=$1
    local bin=$2
    gcc "${src}" -o "${bin}" -lev
    CHECK_RESULT $? 0 0 "Failed to compile ${src}"
}

# Run a compiled binary and save its stdout to a file.
# Usage: libev_run <bin_path> <out_path>
function libev_run() {
    local bin=$1
    local out=$2
    "${bin}" > "${out}"
}

