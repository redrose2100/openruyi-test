#!/usr/bin/bash
# shellcheck disable=SC2086

source ${OET_PATH}/libs/locallibs/common_lib.sh

CURRENT_PATH=$(
  cd "$(dirname "$0")" || exit 1
  pwd
)
target_dir="$(find "${CURRENT_PATH}"/tmp_extract -maxdepth 1 -iname "*libcap-ng*" -type d | head -1)"
if [ -z "${target_dir}" ] || [ ! -d "${target_dir}" ]; then
    echo "libcap-ng directory not found in tmp_extract"
    exit 1
fi
src_path="$(
  cd "${target_dir}" || exit 1
  pwd
)"

dnf install -y make || yum install make -y || apt-get install -y make || true

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

popd || exit 1
