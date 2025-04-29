#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   hua
# @Contact   :   dchang@zhixundn.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of pesign command
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "pesign unzip"
    mkdir pesigntest
    cd pesigntest || exit
    cp ../common/baidu.zip ./
    cp ../common/grubx64.efi ./
    unzip baidu.zip
    pesign -i grubx64.efi -n ./baidu -D
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    pesign-client -? 2>&1 | grep "Usage: pesign-client"
    CHECK_RESULT $? 0 0 "Check pesign-client -? failed"
    pesign-client --help 2>&1 | grep "Usage: pesign-client"
    CHECK_RESULT $? 0 0 "Check pesign-client --help failed"
    pesign-client --usage 2>&1 | grep "Usage: pesign-client"
    CHECK_RESULT $? 0 0 "Check pesign-client --usage failed"
    pesign-client -c 'ALT Linux UEFI SB CA' -q -t 'NSS Certificate DB'
    CHECK_RESULT $? 0 0 "Check pesign-client -c -q -t failed"
    pesign-client --certificate='ALT Linux UEFI SB CA' --is-unlocked --token='NSS Certificate DB'
    CHECK_RESULT $? 0 0 "Check pesign-client --certificate --is-unlocked --token failed"
    echo pesign-client -c 'ALT Linux UEFI SB CA' -u
    CHECK_RESULT $? 0 0 "Check echo pesign-client -c -u failed"
    echo pesign-client -c 'ALT Linux UEFI SB CA' --unlock
    CHECK_RESULT $? 0 0 "Check echo pesign-client -c --unlock failed"
    pesign-client -c 'ALT Linux UEFI SB CA' -q
    CHECK_RESULT $? 0 0 "Check pesign-client -c -q failed"
    pesign-client --certificate='ALT Linux UEFI SB CA' --is-unlocked
    CHECK_RESULT $? 0 0 "Check pesign-client --certificate --is-unlocked failed"
    pesign-client -k
    CHECK_RESULT $? 0 0 "Check pesign-client -k failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    pgrep -f grubx64.efi | xargs -r kill -9
    cd ..
    rm -rf pesigntest
    LOG_INFO "Finish restore the test environment."
}

main "$@"
