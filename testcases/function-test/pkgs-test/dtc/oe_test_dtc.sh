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
# @Author    :   wulei
# @Contact   :   wulei@uniontech.com
# @Date      :   2023-12-12
# @License   :   Mulan PSL v2
# @Desc      :   dtc basic function
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL dtc
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cat > example.dts << EOF
/dts-v1/;

/ {
      model = "Example Device";
      compatible = "example,device";

      memory {
              reg = <0x1000 0x1000>;
      };
};
EOF
    CHECK_RESULT $? 0 0 "File creation failed"
    dtc -I dts -O dtb -o example.dtb example.dts
    CHECK_RESULT $? 0 0 "Compilation failed"
    test -f example.dtb
    CHECK_RESULT $? 0 0 "File generation failed"
    mv example.dts example.dts.bak
    dtc -I dtb -O dts -o example.dts example.dtb
    CHECK_RESULT $? 0 0 "Decompile failed"
    test -f example.dts
    CHECK_RESULT $? 0 0 "File generation failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf example.dts example.dtb example.dts.bak
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"