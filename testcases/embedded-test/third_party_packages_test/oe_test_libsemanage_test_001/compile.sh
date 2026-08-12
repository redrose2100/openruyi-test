#!/usr/bin/bash
# shellcheck disable=SC2086
source ${OET_PATH}/libs/locallibs/common_lib.sh

CURRENT_PATH=$(
  cd "$(dirname "$0")" || exit 1
  pwd
)

dnf install -y make || yum install make -y || apt-get install -y make || true

if [ ! -f "${SDKTARGETSYSROOT}/usr/include/CUnit/Basic.h" ];then
  cunit_dir="$(find "${CURRENT_PATH}"/tmp_extract -maxdepth 1 -iname "*cunit*" -type d | head -1)"
  if [ -z "${cunit_dir}" ] || [ ! -d "${cunit_dir}" ]; then
    echo "CUnit directory not found in tmp_extract"
    exit 1
  fi
  cd "${cunit_dir}" || exit 1
  libtoolize --force --copy && \
  aclocal && \
  autoheader && \
  automake --add-missing --include-deps --copy && \
  autoconf
  ./configure --host="${CROSS_COMPILE%-}" --build="$(gcc -dumpmachine)" --prefix="${SDKTARGETSYSROOT}/usr/"
  make
  make install
  cd "${CURRENT_PATH}" || exit 1
fi

cd "${CURRENT_PATH}"/tmp_extract/libsemanage* || exit 1
if [ ! -f Makefile ]; then
  echo "Makefile not found in libsemanage source directory"
  exit 1
fi
src_path="$(pwd)"
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
cd "${CURRENT_PATH}" || exit 1
