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
# @Author    :   huike
# @Contact   :   754873891@qq.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of nasm command
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "netlabel_tools libselinux"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test"
    netlabelctl mgmt protocols 2>&1 | grep 'UNLABELED'
    CHECK_RESULT $? 0 0 "Check netlabelctl mgmt protocols failed"
    netlabelctl calipso add pass doi:11
    CHECK_RESULT $? 0 0 "Check netlabelctl calipso add pass failed"
    netlabelctl calipso del doi:11
    CHECK_RESULT $? 0 0 "Check netlabelctl calipso del failed"
    netlabelctl calipso add pass doi:11
    netlabelctl calipso list 2>&1 | grep '11'
    CHECK_RESULT $? 0 0 "Check netlabelctl calipso list failed"
    if [ "$(getenforce)" != "Disabled" ]; then
        netlabelctl unlbl add interface:lo address:::1 label:system_u:object_r:netlabel_peer_t:s0
        CHECK_RESULT $? 0 0 "Check netlabelctl calipso unlbl add interface failed"
        netlabelctl unlbl del interface:lo address:::1 label:system_u:object_r:netlabel_peer_t:s0
        CHECK_RESULT $? 0 0 "Check netlabelctl calipso unlbl del interface failed"
        IP="${NODE1_IPV4}"
        IP="${IP%.*}"
        IP="${IP%.*}".0.0/16
        netlabelctl unlbl add default address:"${IP}" label:system_u:object_r:netlabel_peer_t:s0
        CHECK_RESULT $? 0 0 "Check netlabelctl calipso map add default failed"
        netlabelctl unlbl del default address:"${IP}" label:system_u:object_r:netlabel_peer_t:s0
        netlabelctl netlabelctl doi:16
        netlabelctl cipsov4 add trans doi:16 tags:1 levels:0=0,1=1 categories:0=1,1=0
        netlabelctl map add domain:lsm_domain protocol:cipso,16
        CHECK_RESULT $? 0 0 "Check netlabelctl map add failed"
        netlabelctl map del domain:lsm_domain
        netlabelctl map add domain:lsm_domain address:"${NODE1_IPV4}"/00 protocol:cipso,16
        CHECK_RESULT $? 0 0 "Check netlabelctl calipso map add failed"
        netlabelctl map del domain:lsm_domain
    fi
    LOG_INFO "End to run test"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    netlabelctl calipso del doi:11
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
