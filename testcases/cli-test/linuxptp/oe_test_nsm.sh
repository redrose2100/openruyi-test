#!/usr/bin/bash
# Copyright (c) 2023. huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   zhuwenshuo
# @Contact   :   1003254035@qq.com
# @Date      :   2023/02/20
# @License   :   Mulan PSL v2
# @Desc      :   Test cleancss
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "linuxptp tar"
    tar -xvf ./common/data.tar.gz > /dev/null
    LOG_INFO "End of environmental preparation!"
}
function run_test() {
    LOG_INFO "Start to run test."
    nsm -h 2>&1 | grep "usage: nsm"
    CHECK_RESULT $? 0 0 "Failed option: -h"
    nsm -v
    CHECK_RESULT $? 0 0 "Failed option: -v"
    hwstamp_ctl -h 2>&1 | grep "usage: hwstamp_ctl"
    CHECK_RESULT $? 0 0 "Failed option: -h"
    hwstamp_ctl -v
    CHECK_RESULT $? 0 0 "Failed option: -v"
    phc2sys -h 2>&1 | grep "usage: phc2sys"
    CHECK_RESULT $? 0 0 "test phc2sys -h failed"
    phc2sys -v
    CHECK_RESULT $? 0 0 "test phc2sys -v failed"
    phc_ctl -h 2>&1 | grep "usage: phc_ctl"
    CHECK_RESULT $? 0 0 "Failed option: -h"
    phc_ctl -v
    CHECK_RESULT $? 0 0 "Failed option: -v"
    LOG_INFO "Finish test!"
}
function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf ./data
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
           
