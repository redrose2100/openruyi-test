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
# @Date      :   2026-03-24
# @License   :   Mulan PSL v2
# @Desc      :   dtc basic function
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL dtc
    mkdir -p /tmp/dtc_info
    cat > /tmp/dtc_info/info.dts << EOF
/dts-v1/;
/ {
    #address-cells = <1>;
    #size-cells = <1>;
    model = "Info Test Device";
    compatible = "test,info";
    node2@2000 { reg = <0x2000 0x2000>; };
    node1@1000 { reg = <0x1000 0x1000>; };
};
EOF
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    local tmp="/tmp/dtc_info"

    dtc -d ${tmp}/info.dep -I dts -O dtb -o ${tmp}/info_dep.dtb ${tmp}/info.dts
    CHECK_RESULT $? 0 0 "Generate dependency file failed"
    test -f ${tmp}/info.dep
    CHECK_RESULT $? 0 0 "info.dep not generated"

    dtc -s -I dts -O dtb -o ${tmp}/info_sorted.dtb ${tmp}/info.dts
    CHECK_RESULT $? 0 0 "Compile with sort failed"
    test -f ${tmp}/info_sorted.dtb
    CHECK_RESULT $? 0 0 "info_sorted.dtb not generated"

    dtc -T -I dts -O dts -o ${tmp}/info_annot.dts ${tmp}/info.dts
    CHECK_RESULT $? 0 0 "Decompile with annotation failed"
    test -f ${tmp}/info_annot.dts
    CHECK_RESULT $? 0 0 "info_annot.dts not generated"

    dtc -i ${tmp} -I dts -O dtb -o ${tmp}/info_include.dtb ${tmp}/info.dts
    CHECK_RESULT $? 0 0 "Compile with include path failed"
    test -f ${tmp}/info_include.dtb
    CHECK_RESULT $? 0 0 "info_include.dtb not generated"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/dtc_info
    # shellcheck disable=SC2119
 	DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"