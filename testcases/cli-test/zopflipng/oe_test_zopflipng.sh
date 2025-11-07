#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2025/11/06
# @License   :   Mulan PSL v2
# @Desc      :   test zopflipng
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "zopfli ImageMagick"
    convert -size 100x100 xc:red test1.png
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    zopflipng test1.png optimized1.png
    CHECK_RESULT $? 0 0 "Basic compression execution failed"
    zopflipng -q test1.png fast.png
    CHECK_RESULT $? 0 0 "Failed to execute fast compression"
    zopflipng -m test1.png more_compressed.png 
    CHECK_RESULT $? 0 0 "More compression failed to execute"
    zopflipng --iterations=5 test1.png iter5.png
    CHECK_RESULT $? 0 0 "Compression failed to execute the specified number of iterations"
    LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf fast.png iter5.png more_compressed.png optimized1.png test1.png
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
