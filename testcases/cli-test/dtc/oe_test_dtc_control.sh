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
# @Date      :   2026-03-12
# @License   :   Mulan PSL v2
# @Desc      :   dtc basic function
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "dtc"
    mkdir -p /tmp/dtc_control
    cat > /tmp/dtc_control/control.dts << EOF
/dts-v1/;
/ {
    #address-cells = <1>;
    #size-cells = <1>;
    model = "Control Test Device";
    compatible = "test,control";
    node@1000 {
        reg = <0x1000 0x1000>;
        status = "okay";
    };
};
EOF
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    local tmp="/tmp/dtc_control"

    dtc -q -I dts -O dtb -o ${tmp}/control_quiet.dtb ${tmp}/control.dts
    CHECK_RESULT $? 0 0 "Compile with quiet mode (-q) failed"
    test -f ${tmp}/control_quiet.dtb
    CHECK_RESULT $? 0 0 "control_quiet.dtb not generated"

    dtc -qq -I dts -O dtb -o ${tmp}/control_qq.dtb ${tmp}/control.dts
    CHECK_RESULT $? 0 0 "Compile with more quiet mode (-qq) failed"
    test -f ${tmp}/control_qq.dtb
    CHECK_RESULT $? 0 0 "control_qq.dtb not generated"

    dtc -qqq -I dts -O dtb -o ${tmp}/control_qqq.dtb ${tmp}/control.dts
    CHECK_RESULT $? 0 0 "Compile with most quiet mode (-qqq) failed"
    test -f ${tmp}/control_qqq.dtb
    CHECK_RESULT $? 0 0 "control_qqq.dtb not generated"

    dtc -f -I dts -O dtb -o ${tmp}/control_force.dtb ${tmp}/control.dts
    CHECK_RESULT $? 0 0 "Compile with force mode (-f) failed"
    test -f ${tmp}/control_force.dtb
    CHECK_RESULT $? 0 0 "control_force.dtb not generated"

    dtc -q -f -I dts -O dtb -o ${tmp}/control_q_force.dtb ${tmp}/control.dts
    CHECK_RESULT $? 0 0 "Compile with quiet+force mode (-q -f) failed"
    test -f ${tmp}/control_q_force.dtb
    CHECK_RESULT $? 0 0 "control_q_force.dtb not generated"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/dtc_control
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"