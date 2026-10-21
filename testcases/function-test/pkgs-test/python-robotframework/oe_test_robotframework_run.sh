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
# @Author    :   changxuqing
# @Contact   :   changxuqing@uniontech.com
# @Date      :   2023/05/18
# @License   :   Mulan PSL v2
# @Desc      :   test robotframework
# ############################################
# shellcheck disable=SC1090

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "python3-robotframework python3-jsonschema tar"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    if rpm -qa python3-robotframework | grep 4.0.3; then
        tar -xvf RobotDemo/v4.0.3.tar.gz
        CHECK_RESULT $? 0 0 "robotframework-4.0.3 not exist"
        python3 robotframework-4.0.3/utest/run.py -q 2>&1 | grep "OK"
        CHECK_RESULT $? 0 0 "-q failture"pcprebotrobot
        python3 robotframework-4.0.3/utest/run.py -v 2>&1 | grep "OK"
        CHECK_RESULT $? 0 0 "-v failture"
        python3 robotframework-4.0.3/utest/run.py -d 2>&1 | grep "OK"
        CHECK_RESULT $? 0 0 "-d failture"
    fi
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    rm -rf robotframework-4.0.3
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
