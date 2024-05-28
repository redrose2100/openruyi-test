#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   wangshan
#@Contact   	:   wang_shan001@hoperun.com
#@Date      	:   2024-01-24 14:39:43
#@License   	:   Mulan PSL v2
#@Desc      	:   Run pciutils testsuite
#####################################
# shellcheck disable=SC1091
source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start to run pciutils test."
    lspci
    CHECK_RESULT $? 0 0 "check lspci fail"
    if uname -a | grep "aarch64"; then
        lspci -v | grep "00:00.0"
        CHECK_RESULT $? 0 0 "check lspci -v fail"
        lspci -v -nn
        CHECK_RESULT $? 0 0 "check lspci -v -nn fail"
        lspci -t | grep "0000:00"
        CHECK_RESULT $? 0 0 "check lspci -t fail"
        lspci -b | grep "00:00.0"
        CHECK_RESULT $? 0 0 "check lspci -b fail"
    fi
    lspci -x
    CHECK_RESULT $? 0 0 "check lspci -x fail"
    lspci -D
    CHECK_RESULT $? 0 0 "check lspci -D fail"
    lspci -P
    CHECK_RESULT $? 0 0 "check lspci -P fail"
    lspci -PP
    CHECK_RESULT $? 0 0 "check lspci -PP fail"
    setpci --help 2>&1 | grep "Usage"
    CHECK_RESULT $? 0 0 "check setpci --help fail"
    setpci --dumpregs | grep "cap pos w name"
    CHECK_RESULT $? 0 0 "check setpci --dumpregs fail"
    update-pciids 2>&1 | grep -E "download failed|Done."
    CHECK_RESULT $? 0 0 "check update-pciids fail"
    LOG_INFO "End to run pciutils test."
}

main "$@"
