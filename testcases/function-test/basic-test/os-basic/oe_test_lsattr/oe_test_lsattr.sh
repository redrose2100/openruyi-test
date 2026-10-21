#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   xiongneng
# @Contact   :   xiongneng@uniontech.com
# @Date      :   2023/08/09
# @License   :   Mulan PSL v2
# @Desc      :   Using the lsattr command
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    test -d testdir || mkdir testdir
    touch testdir/testfile
    lsattr -l testdir |grep -iE "extents|ext"
    CHECK_RESULT $? 0 0 "Failed to view information"
    lsattr -v testdir |grep -E '^[0-9]'
    CHECK_RESULT $? 0 0 "Unable to view version number information"
    lsattr -R testdir/testfile  |grep -w e
    CHECK_RESULT $? 0 0 "Unable to view attribute information"
    lsattr  testdir |grep -w e
    CHECK_RESULT $? 0 0 "Unable to view attribute information"
    lsattr -d testdir  |grep -w e
    CHECK_RESULT $? 0 0 "Unable to view attribute information"
    lsattr -a testdir  |grep -w testfile
    CHECK_RESULT $? 0 0 "No such file or directory"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf testdir
    LOG_INFO "End to restore the test environment."
}

main "$@"
