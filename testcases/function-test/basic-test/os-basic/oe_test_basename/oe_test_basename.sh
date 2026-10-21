#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xiongneng  wangxiaorou
# @Contact   :   xiongneng05@uniontech.com  wangxiaorou@uniontech.com
# @Date      :   2023-02-02 2024-08-21
# @License   :   Mulan PSL v2
# @Desc      :   basename command test
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start to run test."
    CHECK_RESULT "$(basename /var/log/messages)" "messages" 0 "check file fail"
    CHECK_RESULT "$(basename /var/log/boot.log .log)" "boot" 0 "check suffix file fail"
    CHECK_RESULT "$(basename -s .log /var/log/boot.log )" "boot" 0 "check suffix file fail"

    CHECK_RESULT "$(basename /var/log)" "log" 0 "check dir fail"
    CHECK_RESULT "$(basename /etc/yum.repos.d .repos.d)" "yum" 0 "check suffix dir fail"
    CHECK_RESULT "$(basename /etc/yum.repos.d .repos)" "yum.repos.d" 0 "check suffix dir fail"

    ls ./testdir && rm -rf ./testdir
    mkdir testdir;touch testdir/testfile1 testdir/testfile2
    CHECK_RESULT "$(basename testdir/testfile1 testdir/testfile2)" "testfile1" 0 "check multiple file fail"
    CHECK_RESULT "$(basename -a testdir/testfile1 testdir/testfile2)" "$(ls testdir)" 0 "check multiple file fail"
    CHECK_RESULT "$(basename -az testdir/testfile1 testdir/testfile2)" "testfile1testfile2" 0 "check zero fail"

    basename --version
    CHECK_RESULT $? 0 0 "check version fail"
    CHECK_RESULT "$(basename --version |head -1 |awk '{print $NF}')" "$(rpm -qi coreutils |grep -i Version |awk '{print $NF}')" 0 "check version fail"
    basename --help |grep -Ei '用法|Usage'
    CHECK_RESULT $? 0 0 "check usage fail"

    LOG_INFO "End to run test."
}

main "$@"

