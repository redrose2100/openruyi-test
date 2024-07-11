#!/usr/bin/bash
# shellcheck disable=SC2086
source ${OET_PATH}/libs/locallibs/common_lib.sh

CURRENT_PATH=$(
  cd "$(dirname "$0")" || exit 1
  pwd
)

dnf install -y  make

cunit_path="$(
  cd "${CURRENT_PATH}"/tmp_extract/cunit* || exit 1
  pwd
)"
if [ ! -f "${SDKTARGETSYSROOT}/usr/include/CUnit/Basic.h" ];then
  pushd "${cunit_path}" || exit 1
    libtoolize --force --copy && \
    aclocal && \
    autoheader && \
    automake --add-missing --include-deps --copy && \
    autoconf
    ./configure --host="${CROSS_COMPILE%-}" --build="$(gcc -dumpmachine)" --prefix="${SDKTARGETSYSROOT}/usr/"
    make
    make install
  popd || exit

fi

src_path="$(
  cd "${CURRENT_PATH}"/tmp_extract/libsemanage* || exit 1
  pwd
)"

pushd "${src_path}" || exit 1
# delete tests/Makefile POLICIES
sed -i '/POLICIES = .*/d' tests/Makefile
start_line=$(grep -n '%.policy' tests/Makefile |awk -F ':' '{print $1}')
end_line=$(echo "${start_line}"|awk '{print $1 + 1}')
sed -i "${start_line},${end_line}d" tests/Makefile

if ! make; then
  
  echo "build libsemanage failed!!!"
  exit 1
else
  pushd tests || exit 1
    if ! make libsemanage-tests; then
      echo "build libsemanage-tests failed!!!"
    fi
  popd || exit
fi

cp -r tests "${CURRENT_PATH}"/tmp_test
find "${SDKTARGETSYSROOT}" -name "libcunit.so*" -exec cp {} "${CURRENT_PATH}"/tmp_test/tests \;
popd || exit
