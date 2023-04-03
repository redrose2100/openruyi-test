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
# @Author    :   changxuqing
# @Contact   :   changxuqing@uniontech.com
# @Date      :   2023/04/03
# @License   :   Mulan PSL v2
# @Desc      :   test pkgconf
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "pkgconf pkgconf-devel pkgconf-help xz-devel g++"
    mkdir /libtmp
    cat > /libtmp/test.cpp <<EOF
#include "lzma.h"
#include <iostream>
int main(int argc, char** argv)
{
    const char* version = lzma_version_string();
    std::cout << "lzma version is: " << version << std::endl;
    return 0;
}
EOF
    LOG_INFO "End of environmental preparation!"
}
function run_test() {
  LOG_INFO "Start to run test."
  cd /libtmp/ && g++ -o test test.cpp `pkg-config --cflags --libs liblzma` && ./test 2>&1 | grep "lzma version"
  CHECK_RESULT $? 0 0 "step1 failure"
  LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf /libtmp
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
