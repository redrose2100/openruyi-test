#!/usr/bin/bash
# shellcheck disable=SC2086

source ${OET_PATH}/libs/locallibs/common_lib.sh

CURRENT_PATH=$(
  cd "$(dirname "$0")" || exit 1
  pwd
)
target_dir="$(find "${CURRENT_PATH}"/tmp_extract -maxdepth 1 -iname "*grep*" -type d | head -1)"
if [ -z "${target_dir}" ] || [ ! -d "${target_dir}" ]; then
    echo "grep directory not found in tmp_extract"
    exit 1
fi
src_path=$(
  cd "${target_dir}" || exit 1
  pwd
)

dnf install -y autoconf make || yum install autoconf make -y || apt-get install -y autoconf make || true

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
