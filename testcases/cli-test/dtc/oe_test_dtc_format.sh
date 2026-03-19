#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   guoyejin
# @Contact   :   guoyejin@uniontech.com
# @Date      :   2026-03-19
# @License   :   Mulan PSL v2
# @Desc      :   dtc basic function
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL dtc
    mkdir -p /tmp/dtc_format
    cat > /tmp/dtc_format/basic.dts << EOF
/dts-v1/;
/ {
    #address-cells = <1>;
    #size-cells = <1>;
    model = "Basic Format Test";
    compatible = "test,basic";
};
EOF
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    local tmp="/tmp/dtc_format"

    dtc -I dts -O dtb -o ${tmp}/basic.dtb ${tmp}/basic.dts
    CHECK_RESULT $? 0 0 "Convert dts to dtb failed"
    test -f ${tmp}/basic.dtb
    CHECK_RESULT $? 0 0 "basic.dtb not generated"

    dtc -I dtb -O dts -o ${tmp}/basic_recover.dts ${tmp}/basic.dtb
    CHECK_RESULT $? 0 0 "Convert dtb to dts failed"
    test -f ${tmp}/basic_recover.dts
    CHECK_RESULT $? 0 0 "basic_recover.dts not generated"

    dtc -I dts -O asm -o ${tmp}/basic.asm ${tmp}/basic.dts
    CHECK_RESULT $? 0 0 "Convert dts to asm failed"
    test -f ${tmp}/basic.asm
    CHECK_RESULT $? 0 0 "basic.asm not generated"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/dtc_format
    # shellcheck disable=SC2119
 	DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"