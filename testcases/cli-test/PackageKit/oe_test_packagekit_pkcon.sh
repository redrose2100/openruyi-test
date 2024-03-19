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
# @Author    :   caowenqian
# @Contact   :   caowenqian@uniontech.com
# @Date      :   2023/07/31
# @License   :   Mulan PSL v2
# @Desc      :   Test pkcon function
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "PackageKit"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    if rpm -qa git | grep git;then
        pkcon remove git -y
        CHECK_RESULT $? 0 0 "pkcon remove fail"
        rpm -qa git | grep git
        CHECK_RESULT $? 1 0 "package installed"
	pkcon install git -y
        CHECK_RESULT $? 0 0 "pkcon install fail"
	rpm -qa git | grep git
        CHECK_RESULT $? 0 0 "package not installed"
    else
        pkcon install git -y
        CHECK_RESULT $? 0 0 "pkcon install fail"
        rpm -qa git | grep git
        CHECK_RESULT $? 0 0 "package not installed"
        pkcon remove git -y
        CHECK_RESULT $? 0 0 "pkcon remove fail"
        rpm -qa git | grep git
        CHECK_RESULT $? 1 0 "package installed"
    fi
    pkcon search gcc
    CHECK_RESULT $? 0 0 "pkcon search fail"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
