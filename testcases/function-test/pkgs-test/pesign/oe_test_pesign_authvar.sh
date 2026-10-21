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
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    authvar -? 2>&1 | grep "Usage: authvar"
    CHECK_RESULT $? 0 0 "Check authvar -?  failed"
    authvar --help 2>&1 | grep "Usage: authvar"
    CHECK_RESULT $? 0 0 "Check authvar --help  failed"
    authvar --usage 2>&1 | grep "Usage: authvar"
    CHECK_RESULT $? 0 0 "Check authvar --usage  failed"
    authvar -d ./baidu -n name -v '11' -t 1668869610 -S 'ALT Linux UEFI SB CA' -s -e out -N global && test -f ./out
    CHECK_RESULT $? 0 0 "Check authvar -d -n -v -t -S -s -e -N failed"
    authvar --certdir=./baidu --name=name --value='11' --timestamp=1668869610 --sign='ALT Linux UEFI SB CA' --set --export=out1 --namespace=global && test -f ./out1
    CHECK_RESULT $? 0 0 "Check authvar --certdir --name --value --timestamp --sign --set --export --namespace failed"
    authvar -d ./baidu -n name -v '2' -t 1668869610 -S 'ALT Linux UEFI SB CA' -a -e out2 && test -f ./out2
    CHECK_RESULT $? 0 0 "Check authvar -d -n -v -t -S -a -e failed"
    authvar -d ./baidu -n name -v '2' -t 1668869610 -S 'ALT Linux UEFI SB CA' --append -e out3 && test -f ./out3
    CHECK_RESULT $? 0 0 "Check authvar -d -n -v -t -S --append -e failed"
    authvar -d ./baidu -c -S 'ALT Linux UEFI SB CA' -n name -e out4 && test -f ./out4
    CHECK_RESULT $? 0 0 "Check authvar -d -c -S -n -e failed"
    authvar -d ./baidu --clear -S 'ALT Linux UEFI SB CA' -n name -e out5 && test -f ./out5
    CHECK_RESULT $? 0 0 "Check authvar -d --clear -S -n -e failed"
    authvar -f out -d ./baidu -S 'ALT Linux UEFI SB CA' -s -n name -e out6 && test -f ./out6
    CHECK_RESULT $? 0 0 "Check authvar -f failed"
    authvar --valuefile=out -d ./baidu -S 'ALT Linux UEFI SB CA' -s -n name -e out7 && test -f ./out7
    CHECK_RESULT $? 0 0 "Check authvar --valuefilefailed"
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
