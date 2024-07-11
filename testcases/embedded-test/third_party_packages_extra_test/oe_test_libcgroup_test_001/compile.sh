#!/usr/bin/bash
# shellcheck disable=SC2086
source ${OET_PATH}/libs/locallibs/common_lib.sh

CURRENT_PATH=$(
  cd "$(dirname "$0")" || exit 1
  pwd
)
googletest_url="https://codeload.github.com/google/googletest/zip/ec44c6c1675c25b9827aacd08c02433cccde7780"
src_path="$(
  cd "${CURRENT_PATH}"/tmp_extract/libcgroup* || exit 1
  pwd
)"

dnf install -y  make autoconf unzip

pushd "${src_path}" || exit 1
autoreconf -vif
./configure --host="${CROSS_COMPILE%-}" --build="$(gcc -dumpmachine)"

if ! make; then
  echo "build libcgroup failed!!!"
  exit 1
fi
# build ftests
# TODO ftests dependent python

# build gunit
cd googletest/ || exit 1
wget -O googletest.zip ${googletest_url}
unzip googletest.zip
mv googletest-*/googletest .
cd googletest || exit 1
mkdir build_dir
cd build_dir || exit 1
cmake -DBUILD_SHARED_LIBS=ON ../
make
if [ -f libgtest.so ]; then
  if [ -n "${SDKTARGETSYSROOT}" ]; then
    cp libgtest.so "${SDKTARGETSYSROOT}/usr/lib64/"
  else
    cp libgtest.so /usr/lib64/
  fi
  cp libgtest.so "${CURRENT_PATH}/tmp_test/"
else
  echo "build googletest failed!!!"
  exit 1
fi
cd "${src_path}"/tests/gunit || exit 1

if ! make gtest; then
  echo "build gtest failed!!!"
  exit 1
fi
cd .. || exit 1
cp -r gunit "${CURRENT_PATH}"/tmp_test

popd || exit
