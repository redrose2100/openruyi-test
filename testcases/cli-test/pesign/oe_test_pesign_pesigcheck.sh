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

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL pesign
    mkdir pesigntest
    cd pesigntest
    cp ../common/baidu.zip ./
    cp ../common/grubx64.efi ./
    unzip baidu.zip
    pesign -i grubx64.efi -o grubx64.efi.signed -c 'ALT Linux UEFI SB CA' -s -n ./baidu -t 'NSS Certificate DB' -a -v -p -P -N
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    pesigcheck -? 2>&1 | grep "Usage: pesigcheck"
    CHECK_RESULT $? 0 0 "Check pesigcheck -? failed"
    pesigcheck --help 2>&1 | grep "Usage: pesigcheck"
    CHECK_RESULT $? 0 0 "Check pesigcheck --help failed"
    pesigcheck --usage 2>&1 | grep "Usage: pesigcheck"
    CHECK_RESULT $? 0 0 "Check pesigcheck --usage failed"
    pesigcheck -i grubx64.efi -q -v -n 1 -D ./baidu/cert9.db | grep "Searching db cert9.db"
    CHECK_RESULT $? 0 0 "Check pesigcheck -i -q -v -n -D failed"
    pesigcheck --in=grubx64.efi --quiet --verbose --no-system-db=1 --dbfile=./baidu/cert9.db | grep "Searching db cert9.db"
    CHECK_RESULT $? 0 0 "Check pesigcheck --in --quiet --verbose --no-system-db --dbfile failed"
    pesigcheck -i grubx64.efi -q -v -n 1 -X ./baidu/cert9.db -c grubx64.efi.signed | grep "Searching dbx cert9.db"
    CHECK_RESULT $? 0 0 "Check pesigcheck -i -q -v -n -X -c failed"
    pesigcheck --in=grubx64.efi --quiet --verbose --no-system-db=1 --dbxfile=./baidu/cert9.db --certfile=grubx64.efi.signed | grep "Searching dbx cert9.db"
    CHECK_RESULT $? 0 0 "Check pesigcheck --in --quiet --verbose --no-system-db --dbxfile --certfile failed"
    authvar -i ./test -d ./baidu
    CHECK_RESULT $? 0 0 "Check authvar -i -d failed"
    authvar -l -d ./baidu
    CHECK_RESULT $? 0 0 "Check authvar -l -d failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    ps -ef | grep grubx64.efi | grep -v grep | awk '{print $2}' | xargs kill -9
    cd ..
    rm -rf pesigntest
    LOG_INFO "Finish restore the test environment."
}

main "$@"
