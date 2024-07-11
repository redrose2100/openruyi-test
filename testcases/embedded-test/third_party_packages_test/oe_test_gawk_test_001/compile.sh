#!/usr/bin/bash
# shellcheck disable=SC2086,SC2010

source ${OET_PATH}/libs/locallibs/common_lib.sh

CURRENT_PATH=$(
  cd "$(dirname "$0")" || exit 1
  pwd
)
src_path=$(
  cd "${CURRENT_PATH}"/tmp_extract/gawk*/ || exit 1
  pwd
)

dnf install -y  autoconf make mpfr-devel gmp-devel

pushd "${src_path}" || exit 1
autoreconf -fv

./configure --host="${CROSS_COMPILE%-}" --build="$(gcc -dumpmachine)" --enable-math-libs

if make; then
  pushd test || exit 1
    echo -n > all_test.txt
    shopt -s nullglob
    for test_awk in *.awk
    do
      test_item=$(basename "${test_awk}" .awk)
      if make -n "${test_item}"|grep -v '^make\[' > "${test_item}".test;then
        echo "${test_item}" >> all_test.txt
      fi
    done
  popd || exit 1
  cp -r "${src_path}/gawk" "${CURRENT_PATH}/tmp_test"
  cp -r "${src_path}/test" "${CURRENT_PATH}/tmp_test"
  cp -r "${src_path}/extension" "${CURRENT_PATH}/tmp_test"
else
  echo "build gawk failed!!!"
  exit 1
fi
popd || exit 1

