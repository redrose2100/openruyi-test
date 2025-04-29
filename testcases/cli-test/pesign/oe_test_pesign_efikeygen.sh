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
    cd pesigntest || exit 1
    cp ../common/demo.zip ./
    unzip demo.zip
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    efikeygen -? 2>&1 | grep "Usage: efikeygen"
    CHECK_RESULT $? 0 0 "Check efikeygen -? failed"
    efikeygen --help 2>&1 | grep "Usage: efikeygen"
    CHECK_RESULT $? 0 0 "Check efikeygen --help failed"
    efikeygen --usage 2>&1 | grep "Usage: efikeygen"
    CHECK_RESULT $? 0 0 "Check efikeygen --usage failed"
    efikeygen -d ./demo -S -n 'ALT Linux UEFI SB CA' -c 'CN=ALT UEFI SB CA 2013,OU=ALT Certification Authority,O=ALT Linux Team,C=RU' -u 'http://www.baidu.com' -k -s 00
    CHECK_RESULT $? 0 0 "Check efikeygen -d -S -n -c -u -k -s failed"
    efikeygen -d ./demo -t "NSS Certificate DB" --signer='ALT Linux UEFI SB CA' -n 'ALT Linux UEFI SB Signer' -c'CN=ALT UEFI SB Signer 2013,OU=ALT Certification Authority,O=ALT Linux Team,C=RU' --kernel -u 'http://www.baidu.com' -s 01
    CHECK_RESULT $? 0 0 "Check efikeygen -d t --signer -c --kernel -u -s failed"
    rm -rf demo
    unzip demo.zip
    efikeygen -d ./demo --self-sign --nickname='ALT Linux UEFI SB CA' --common-name='CN=ALT UEFI SB CA 2013,OU=ALT Certification Authority,O=ALT Linux Team,C=RU' --url='http://www.baidu.com' -m --serial=00
    CHECK_RESULT $? 0 0 "Check efikeygen -d --self-sign --nickname --common-name --url -m --serial failed"
    efikeygen -d ./demo --token="NSS Certificate DB" --signer='ALT Linux UEFI SB CA' --nickname='ALT Linux UEFI SB Signer' --common-name='CN=ALT UEFI SB Signer 2013,OU=ALT Certification Authority,O=ALT Linux Team,C=RU' --module --url='http://www.baidu.com' --serial=01
    CHECK_RESULT $? 0 0 "Check efikeygen -d --token --signer --nickname --common-name --module --url --serial failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    cd ..
    rm -rf pesigntest
    LOG_INFO "Finish restore the test environment."
}

main "$@"
