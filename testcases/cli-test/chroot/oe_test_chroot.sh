#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   liliqi
# @Contact   :   liliqi@uniontech.com
# @Date      :   2023/04/13
# @License   :   Mulan PSL v2
# @Desc      :   chroot命令测试
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    mkdir testroot	
    cd testroot
    mkdir bin lib lib64
    cp /bin/bash bin/
    cp /bin/ls bin/
    cp -r /lib/* lib/
    cp -r /lib64/* lib64/
    cd ..
    out=$(chroot testroot /bin/bash -c "pwd" | grep /)
    CHECK_RESULT $out / 0 "chroot command execution failed"
}
   
function post_test() {
  LOG_INFO "start environment cleanup."
  rm -rf testroot
  LOG_INFO "Finish environment cleanup!"
}
main "$@"

