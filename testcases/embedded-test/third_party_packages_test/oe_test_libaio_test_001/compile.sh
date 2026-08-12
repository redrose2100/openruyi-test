#!/usr/bin/bash
# shellcheck disable=SC2086
source ${OET_PATH}/libs/locallibs/common_lib.sh

CURRENT_PATH=$(
  cd "$(dirname "$0")" || exit 1
  pwd
)
target_dir="$(find "${CURRENT_PATH}"/tmp_extract -maxdepth 1 -iname "*libaio*" -type d | head -1)"
if [ -z "${target_dir}" ] || [ ! -d "${target_dir}" ]; then
    echo "libaio directory not found in tmp_extract"
    exit 1
fi
src_path="$(
  cd "${target_dir}" || exit 1
  pwd
)"

dnf install -y make || yum install make -y || apt-get install -y make || true

pushd "${src_path}" || exit 1
make
cd harness || exit 1
# 特殊处理 cases/5.t, 避免后期因目录挂载导致该用例失败
sed -i 's#testdir/rwfile#/testdir/rwfile#' cases/5.t
if ! make; then
  echo "build libaio failed!!!"
  exit 1
fi
cd - || exit 1
cp -r harness/* "${CURRENT_PATH}"/tmp_test
popd || exit 1
