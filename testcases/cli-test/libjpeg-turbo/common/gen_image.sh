#!/bin/bash
# Common helpers for libjpeg-turbo test cases.

# Generate a PPM (P6) image with a simple gradient pattern.
#   $1: output path
#   $2: width  (default 32)
#   $3: height (default 24)
gen_ppm_image() {
    local out="$1"
    local width="${2:-32}"
    local height="${3:-24}"
    python3 - "$out" "$width" "$height" <<'PY'
import sys

path, width, height = sys.argv[1], int(sys.argv[2]), int(sys.argv[3])
with open(path, "wb") as image:
    image.write(f"P6\n{width} {height}\n255\n".encode())
    for y in range(height):
        for x in range(width):
            image.write(bytes(((x * 8) % 256, (y * 10) % 256, ((x + y) * 5) % 256)))
PY
}

# Encode a PPM image into a JPEG using cjpeg.
#   $1: input PPM path
#   $2: output JPEG path
#   $3: quality (default 90)
gen_jpeg_image() {
    local ppm="$1"
    local jpg="$2"
    local quality="${3:-90}"
    cjpeg -quality "$quality" -outfile "$jpg" "$ppm"
}
