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
# @Author    :   sunqingwei
# @Contact   :   sunqingwei@uniontech.com
# @Date      :   2023/03/31
# @License   :   Mulan PSL v2
# @Desc      :   Test PDFS are separated into pictures
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL ghostscript
    mkdir /tmp/test
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    gs -dQUIET -dNOSAFER -r300 -dBATCH -sDEVICE=pngalpha -dNOPAUSE -dNOPROMPT -sOutputFile=/tmp/test/%d.png -f ./1.pdf
    CHECK_RESULT $? 0 0 "Execution failure"
    for i in {1..15}
    do
            test -e /tmp/test/$i.png
            CHECK_RESULT $? 0 0 "Generation failure"
    done
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf /tmp/test
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
