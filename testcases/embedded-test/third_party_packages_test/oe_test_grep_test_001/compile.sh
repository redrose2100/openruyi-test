#!/usr/bin/bash
# shellcheck disable=SC2086

source ${OET_PATH}/libs/locallibs/common_lib.sh

CURRENT_PATH=$(
  cd "$(dirname "$0")" || exit 1
  pwd
)
src_path=$(
  cd "${CURRENT_PATH}"/tmp_extract/grep*/ || exit 1
  pwd
)

dnf install -y  autoconf make

pushd "${src_path}" || exit 1
autoreconf -f
./configure --host="${CROSS_COMPILE%-}" --build="$(gcc -dumpmachine)"
make

cd tests || exit 1

if make get-mb-cur-max; then
  cp -r "${src_path}/tests" "${CURRENT_PATH}/tmp_test"
else
  echo "build grep failed!!!"
  exit 1
fi
popd || exit 1
