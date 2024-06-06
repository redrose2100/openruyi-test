#!/bin/sh
# shellcheck disable=SC1091,SC3044,SC2039
src_dir=$1


if [ ! -d "$src_dir" ]; then
  echo "Error: build failed, src dir invalid. "
  exit 1
fi

pushd "$src_dir" || exit 5
if ! make; then
  popd || true
  echo "Error: Make zstd Failed"
  exit 2
fi
pushd tests || exit 5

if ! make datagen; then
  echo "Error: Make datagen Failed"
  exit 4
fi
popd || true
popd || true

echo 'Build Ok'
