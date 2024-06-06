#!/bin/sh
# shellcheck disable=SC1091,SC3044,SC2039
src_dir=$1


if [ ! -d "$src_dir" ]; then
	echo "Error: build failed, src dir invalid. "
	exit 1
fi


pushd "$src_dir" || exit 5
./configure

if ! make distro; then
	popd || true
	echo "compile error"
        exit 3
else
	popd || true    
	echo "compile ok"
fi

