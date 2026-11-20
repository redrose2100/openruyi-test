#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   gaoshuaishuai
# @Contact   :   gaoshuaishuai@uniontech.com
# @Date      :   2024/01/09
# @License   :   Mulan PSL v2
# @Desc      :   test squashfs-tools 
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "squashfs-tools zstd xz cpio"
  path=/tmp/test_squashfs-tools
  mkdir "${path}"
  kernel=$(uname -r)
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  cp /boot/initramfs-"${kernel}".img "${path}"
  cd "${path}" || exit 1
  # initramfs 的压缩算法随内核配置变化（gzip/xz/zstd/未压缩），按魔数依次尝试解压
  initrd_img="${path}"/initramfs-"${kernel}".img
  if [ "$(head -c 2 "${initrd_img}" | od -An -tx1 | tr -d ' \n')" = "1f8b" ]; then
    decomp_cmd="zcat"
  elif [ "$(head -c 6 "${initrd_img}" | od -An -tx1 | tr -d ' \n')" = "fd377a585a00" ]; then
    decomp_cmd="xz -dc"
  elif [ "$(head -c 4 "${initrd_img}" | od -An -tx1 | tr -d ' \n')" = "28b52ffd" ]; then
    decomp_cmd="zstd -dc"
  else
    decomp_cmd="cat"
  fi
  ${decomp_cmd} "${initrd_img}" | cpio -id 2>/dev/null
  CHECK_RESULT $? 0 0 "Initrd.img decompression failed"
  mksquashfs "${path}" squashtest.squashfs
  CHECK_RESULT $? 0 0 "Mksqueshfs production failed"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf "${path}"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
