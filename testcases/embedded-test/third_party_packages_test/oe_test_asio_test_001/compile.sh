#!/usr/bin/bash
# shellcheck disable=SC2086

source ${OET_PATH}/libs/locallibs/common_lib.sh

CURRENT_PATH=$(
  cd "$(dirname "$0")" || exit 1
  pwd
)
src_path=$(
  cd "${CURRENT_PATH}"/tmp_extract/asio*/ || exit 1
  pwd
)

dnf install -y autoconf make

pushd "${src_path}" || exit 1
./configure --host="${CROSS_COMPILE%-}" --build="$(gcc -dumpmachine)"
make
cd src/tests || exit 1

cat Makefile >print_suite.mk
cat >>print_suite.mk <<EOF
.PHONY: print_suite
print_suite:
        \$(info suite=\$(check_PROGRAMS))
EOF
make -f print_suite.mk print_suite|grep suite=|awk -F '=' '{print $2}'|sed 's/ /\n/g' > test_list

while read -r line || [[ -n "${line}" ]]; do
  if ! make ${line};then
     LOG_ERROR "make ${line} failed!!!"
  else
     echo ${line} >> success_list
  fi
done < test_list

if [ "$(wc -l < success_list)" -gt 0 ]; then
  cp -r "${src_path}/src/tests" "${CURRENT_PATH}/tmp_test"
else
  echo "build asio failed!!!"
  exit 1
fi
popd || exit 1
