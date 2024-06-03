#!/usr/bin/bash
# shellcheck disable=SC2086

source ${OET_PATH}/libs/locallibs/common_lib.sh

CURRENT_PATH=$(
  cd "$(dirname "$0")" || exit 1
  pwd
)
src_path="$(
  cd "${CURRENT_PATH}"/tmp_extract/libcap-ng* || exit 1
  pwd
)"

dnf install -y  make

pushd "${src_path}" || exit 1

./configure --host="${CROSS_COMPILE%-}" --build="$(gcc -dumpmachine)"
cd src || exit 1
make

cd test || exit 1
# build lib_test
if ! make lib_test; then
  echo "build lib_test failed!!!"
  exit 1
fi
# build thread_test
if ! make thread_test; then
  echo "build thread_test failed!!!"
  exit 1
fi
cd - || exit 1
cp -r test "${CURRENT_PATH}"/tmp_test

popd || exit
