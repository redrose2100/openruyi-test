#!/usr/bin/bash
# shellcheck disable=SC2086
source ${OET_PATH}/libs/locallibs/common_lib.sh

CURRENT_PATH=$(
  cd "$(dirname "$0")" || exit 1
  pwd
)

src_path="$(
  cd "${CURRENT_PATH}"/tmp_extract/sudo* || exit 1
  pwd
)"
dnf install -y  autoconf make

pushd ${src_path} || exit 1
autoreconf -f
./configure --host="${CROSS_COMPILE%-}" --build="$(gcc -dumpmachine)"

if ! make; then
  echo "build sudo failed!!!"
  exit 1
fi
# make test
pushd lib || exit 1
for dir_name in ./*/
do
  pushd "${dir_name}" || exit 1
  cat Makefile >print_test.mk
cat >>print_test.mk <<EOF
.PHONY: print_test
print_test:
        \$(info tests=\$(TEST_PROGS))
EOF
  make -f print_test.mk print_test|grep tests=|awk -F '=' '{print $2}'|sed 's/ /\n/g' > test_list
  while read -r test_file; do
    if [ -z "${test_file}" ];then
      continue
    fi
    make "${test_file}"
  done < ./test_list
  popd || exit 0
done
popd || exit 0
cp -r lib ${CURRENT_PATH}/tmp_test
popd || exit 0
