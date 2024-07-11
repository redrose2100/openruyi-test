#!/usr/bin/bash
# shellcheck disable=SC2086
source ${OET_PATH}/libs/locallibs/common_lib.sh
CURRENT_PATH=$(
  cd "$(dirname "$0")" || exit 1
  pwd
)

src_path="$(
  cd "${CURRENT_PATH}"/tmp_extract/tcl* || exit 1
  pwd
)"
pushd "${src_path}"/unix || exit

dnf install -y  make

./configure --host="${CROSS_COMPILE%-}" --build="$(gcc -dumpmachine)" --enable-threads --enable-symbols --enable-dtrace

# build tcltest
make tcltest

cat Makefile >print_version.mk
cat >>print_version.mk <<EOF
.PHONY: print_version
print_version:
        \$(info VERSION=\$(VERSION))
EOF
make -f print_version.mk print_version | grep VERSION= | awk -F '=' '{print $2}' >"${CURRENT_PATH}/tmp_test/VERSION"

exec_path="${CURRENT_PATH}/tmp_test/"
tcltest=${src_path}/unix/tcltest
if [ -f "${tcltest}" ]; then
  \cp -r "${src_path}"/library "${exec_path}"
  \cp -r "${src_path}"/tests "${exec_path}"
  \cp "${tcltest}" "${exec_path}"
else
  echo "tcltest build failed"
  exit 1
fi

popd || exit
