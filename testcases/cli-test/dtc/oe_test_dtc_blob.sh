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
# @Date      :   2026-03-17
# @License   :   Mulan PSL v2
# @Desc      :   dtc basic function
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL dtc
    mkdir -p /tmp/dtc_blob
    cat > /tmp/dtc_blob/blob.dts << EOF
/dts-v1/;
/ {
    model = "Blob Test Device";
    compatible = "test,blob";
    memory { reg = <0x1000 0x1000>; };
};
EOF
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    local tmp="/tmp/dtc_blob"

    dtc -V 17 -I dts -O dtb -o ${tmp}/blob_v17.dtb ${tmp}/blob.dts
    CHECK_RESULT $? 0 0 "Compile with blob version 17 failed"
    test -f ${tmp}/blob_v17.dtb
    CHECK_RESULT $? 0 0 "blob_v17.dtb not generated"

    dtc -R 5 -I dts -O dtb -o ${tmp}/blob_reserve.dtb ${tmp}/blob.dts
    CHECK_RESULT $? 0 0 "Compile with reserve map failed"
    test -f ${tmp}/blob_reserve.dtb
    CHECK_RESULT $? 0 0 "blob_reserve.dtb not generated"

    dtc -S 4096 -I dts -O dtb -o ${tmp}/blob_space.dtb ${tmp}/blob.dts
    CHECK_RESULT $? 0 0 "Compile with minimum space failed"
    test -f ${tmp}/blob_space.dtb
    CHECK_RESULT $? 0 0 "blob_space.dtb not generated"

    dtc -p 1024 -I dts -O dtb -o ${tmp}/blob_pad.dtb ${tmp}/blob.dts
    CHECK_RESULT $? 0 0 "Compile with padding failed"
    test -f ${tmp}/blob_pad.dtb
    CHECK_RESULT $? 0 0 "blob_pad.dtb not generated"

    dtc -a 8 -b 0 -I dts -O dtb -o ${tmp}/blob_align_boot.dtb ${tmp}/blob.dts
    CHECK_RESULT $? 0 0 "Compile with align and boot CPU failed"
    test -f ${tmp}/blob_align_boot.dtb
    CHECK_RESULT $? 0 0 "blob_align_boot.dtb not generated"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/dtc_blob
    # shellcheck disable=SC2119
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"