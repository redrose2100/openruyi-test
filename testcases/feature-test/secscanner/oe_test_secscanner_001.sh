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
# @Author    :   kangjiangbo
# @Contact   :   kangjiangbo_yewu@cmss.chinamobile.com
# @Date      :   2026-2-27
# @License   :   Mulan PSL v2
# @Desc      :   Regular users are not allowed to run secscanner
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    yum search secScanner || exit 255
    DNF_INSTALL "secScanner"
    id test && userdel -rf test
	useradd test
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."
    su -c "secscanner -h" -test
    CHECK_RESULT $? 1 0 "Regular users are not allowed to run secscanner."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    userdel -rf test
    LOG_INFO "End to restore the test environment."
}

main "$@"