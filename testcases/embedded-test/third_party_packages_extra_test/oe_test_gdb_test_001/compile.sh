#!/usr/bin/bash
# shellcheck disable=SC2086
source ${OET_PATH}/libs/locallibs/common_lib.sh

CURRENT_PATH=$(
  cd "$(dirname "$0")" || exit 1
  pwd
)
testsuite_path="$(
  cd "${CURRENT_PATH}"/tmp_extract/gdb*/gdb/testsuite || exit 1
  pwd
)"
dnf install -y  make

# build test
pushd ${testsuite_path} || exit 1
./configure --host="${CROSS_COMPILE%-}" --build="$(gcc -dumpmachine)"

if make site.exp; then
  exec_path="${CURRENT_PATH}/tmp_test/"
  cp -r ${testsuite_path} "${exec_path}"
fi
popd || exit
