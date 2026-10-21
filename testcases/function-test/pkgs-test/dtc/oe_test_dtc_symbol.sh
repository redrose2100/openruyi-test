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
# @Date      :   2026-03-23
# @License   :   Mulan PSL v2
# @Desc      :   dtc basic function
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL dtc
    mkdir -p /tmp/dtc_symbol
    cat > /tmp/dtc_symbol/symbol.dts << EOF
/dts-v1/;
/ {
    #address-cells = <1>;
    #size-cells = <1>;
    model = "Symbol Test Device";
    compatible = "test,symbol";
    phandle = <0x12345678>;
    test_label: node@1000 {
        reg = <0x1000 0x1000>;
        status = "okay";
    };
};
EOF
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    local tmp="/tmp/dtc_symbol"

    dtc -@ -I dts -O dtb -o ${tmp}/symbol_only_sym.dtb ${tmp}/symbol.dts
    CHECK_RESULT $? 0 0 "Compile with symbol generation only (-@) failed"
    test -f ${tmp}/symbol_only_sym.dtb
    CHECK_RESULT $? 0 0 "symbol_only_sym.dtb not generated"

    dtc -A -I dts -O dtb -o ${tmp}/symbol_only_alias.dtb ${tmp}/symbol.dts
    CHECK_RESULT $? 0 0 "Compile with auto alias only (-A) failed"
    test -f ${tmp}/symbol_only_alias.dtb
    CHECK_RESULT $? 0 0 "symbol_only_alias.dtb not generated"

    dtc -H epapr -I dts -O dtb -o ${tmp}/symbol_only_phandle_epapr.dtb ${tmp}/symbol.dts
    CHECK_RESULT $? 0 0 "Compile with phandle (epapr) only (-H epapr) failed"
    test -f ${tmp}/symbol_only_phandle_epapr.dtb
    CHECK_RESULT $? 0 0 "symbol_only_phandle_epapr.dtb not generated"

    dtc -H both -I dts -O dtb -o ${tmp}/symbol_only_phandle_both.dtb ${tmp}/symbol.dts
    CHECK_RESULT $? 0 0 "Compile with phandle (both) only (-H both) failed"
    test -f ${tmp}/symbol_only_phandle_both.dtb
    CHECK_RESULT $? 0 0 "symbol_only_phandle_both.dtb not generated"

    dtc -@ -A -I dts -O dtb -o ${tmp}/symbol_sym_alias.dtb ${tmp}/symbol.dts
    CHECK_RESULT $? 0 0 "Compile with symbols+auto alias (-@ -A) failed"
    test -f ${tmp}/symbol_sym_alias.dtb
    CHECK_RESULT $? 0 0 "symbol_sym_alias.dtb not generated"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/dtc_symbol
    # shellcheck disable=SC2119
 	DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"