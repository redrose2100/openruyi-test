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
# @Author    :   doraemon2020
# @Contact   :   xcl_job@163.com
# @Date      :   2020-04-09
# @License   :   Mulan PSL v2
# @Desc      :   Delete User Group test
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    grep "testgroup:" /etc/group && groupdel testgroup
    grep "testgroup_nonexist:" /etc/group && groupdel testgroup_nonexist
    grep "testgroup_primary:" /etc/group && groupdel testgroup_primary
    grep "testgroup_secondary:" /etc/group && groupdel testgroup_secondary
    id testuser_primary && userdel -f testuser_primary
    id testuser_secondary && userdel -f testuser_secondary

    groupadd testgroup
    groupadd testgroup_primary
    groupadd testgroup_secondary
    useradd -g testgroup_primary testuser_primary
    useradd testuser_secondary
    usermod -aG testgroup_secondary testuser_secondary

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    grep "testgroup:" /etc/group
    CHECK_RESULT $? 0 0 "check testgroup fail"
    groupdel testgroup
    CHECK_RESULT $? 0 0 "run groupdel testgroup fail"
    grep "testgroup:" /etc/group
    CHECK_RESULT $? 1 0 "check del testgroup fail"
    LANG=C groupdel --help 2>&1 | grep "Usage: groupdel"
    CHECK_RESULT $? 0 0 "check groupdel help fail"

    groupdel testgroup_nonexist 2>/dev/null
    CHECK_RESULT $? 6 0 "groupdel should fail for non-existent group"

    groupdel testgroup_primary
    CHECK_RESULT $? 8 0 "groupdel should fail when group is primary group"

    groups testuser_secondary | grep testgroup_secondary
    CHECK_RESULT $? 0 0 "testuser_secondary should have testgroup_secondary"
    groupdel testgroup_secondary
    CHECK_RESULT $? 0 0 "groupdel should succeed for secondary group"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    grep "testgroup:" /etc/group && groupdel testgroup
    grep "testgroup_nonexist:" /etc/group && groupdel testgroup_nonexist
    grep "testgroup_primary:" /etc/group && groupdel testgroup_primary
    grep "testgroup_secondary:" /etc/group && groupdel testgroup_secondary
    id testuser_primary && userdel -f testuser_primary
    id testuser_secondary && userdel -f testuser_secondary

    LOG_INFO "End to restore the test environment."
}

main "$@"