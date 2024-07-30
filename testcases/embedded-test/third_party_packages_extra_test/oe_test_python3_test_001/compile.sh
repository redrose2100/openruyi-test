#!/usr/bin/bash
# shellcheck disable=SC2035,SC2086
source ${OET_PATH}/libs/locallibs/common_lib.sh
CURRENT_PATH=$(
  cd "$(dirname "$0")" || exit 1
  pwd
)

src_path="$(
  cd "${CURRENT_PATH}"/tmp_extract/Python* || exit 1
  pwd
)"
pushd "${src_path}" || exit 1

dnf install -y  autoconf autoconf-archive

autoconf -f
if [ -n "${TARGET_PREFIX}" ]; then
  ./configure --host="${CROSS_COMPILE%-}" --build="$(gcc -dumpmachine)" --with-build-python="$(command -v python3)" ac_cv_file__dev_ptmx="yes" ac_cv_file__dev_ptc="no"
else
  ./configure
fi

if make; then
  cp -r * "${CURRENT_PATH}"/tmp_test/
else
  echo "python3 build failed"
  exit 1
fi

popd || exit
