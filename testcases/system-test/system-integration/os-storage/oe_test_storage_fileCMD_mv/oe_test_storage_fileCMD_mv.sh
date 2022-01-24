#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xuchunlin
# @Contact   :   xcl_job@163.com
# @Date      :   2020-04-10
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-mv
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start environment preparation."
    current_path=$(
        cd "$(dirname $0)" || exit 1
        pwd
    )
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase!"
    sudo mkdir test1
    sudo mv test1 /home
    cd /home && ls | grep "test1"
    CHECK_RESULT $?

    sudo mv test1 haha && ls | grep "haha"
    CHECK_RESULT $?
    rm -rf /home/haha

    cd / && mkdir haha && sudo mv -f haha /home
    ls / | grep "haha"
    CHECK_RESULT $? 1
    cd /home && ls | grep "haha"
    CHECK_RESULT $?

    mv --help | grep "Usage"
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /home/haha
    cd ${current_path} || exit 1
    LOG_INFO "Finish environment cleanup."
}

main $@
