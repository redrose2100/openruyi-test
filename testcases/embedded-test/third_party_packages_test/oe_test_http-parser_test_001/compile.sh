#!/bin/sh
# shellcheck disable=SC1091,SC3044,SC2039
src_dir=$1


if [ ! -d "$src_dir" ]; then
  echo "Error: build failed, src dir invalid. "
  exit 1
fi


pushd "$src_dir" || exit 5
sed -i 's/ -Werror//' Makefile

if ! make library; then
  popd || true
  echo "make build error"
  exit 3
else
  echo "make build ok"
fi

if ! make test_g; then
  popd || true
  echo "make test error"
  exit 3
else
  echo "make test ok"
fi

if ! make test_fast; then
  popd || true
  echo "make test error"
  exit 3
else
  popd || true
  echo "make test ok"
fi
