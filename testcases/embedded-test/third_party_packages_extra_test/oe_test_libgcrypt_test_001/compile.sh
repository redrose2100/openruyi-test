#!/usr/bin/bash
# shellcheck disable=SC2086
source ${OET_PATH}/libs/locallibs/common_lib.sh

CURRENT_PATH=$(
  cd "$(dirname "$0")" || exit 1
  pwd
)

src_path="$(
  cd "${CURRENT_PATH}"/tmp_extract/libgcrypt* || exit 1
  pwd
)"
dnf install -y  autoconf make libgpg-error-devel

pushd ${src_path} || exit 1
autoreconf -f
./configure --host="${CROSS_COMPILE%-}" --build="$(gcc -dumpmachine)"

if ! make; then
  echo "build libgcrypt failed!!!"
  exit 1
fi
cd tests || exit 1

cat Makefile >print_test.mk
cat >>print_test.mk <<EOF
.PHONY: print_tests
print_tests:
        \$(info TESTS=\$(TESTS))
EOF
make -f print_test.mk print_tests | grep TESTS= | awk -F '=' '{print $2}' >test_program
cd .. || exit 1

cp -r tests ${CURRENT_PATH}/tmp_test

popd || exit 0
