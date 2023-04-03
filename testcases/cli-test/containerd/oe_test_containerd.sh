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
# @Author    :   wulei
# @Contact   :   wulei@uniontech.com
# @Date      :   2023/04/03
# @License   :   Mulan PSL v2
# @Desc      :   containerd command validation
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "containerd docker-runc"
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    nohup containerd &
    ctr images pull docker.io/library/nginx:latest
    ctr images ls | grep 'docker.io'
    CHECK_RESULT $? 0 0 "Image removal failed"
    ctr c create docker.io/library/nginx:latest nginx-container
    ctr c ls | grep 'nginx-container'
    CHECK_RESULT $? 0 0 "Container creation failed"
    ctr t start -d nginx-container
    CHECK_RESULT $? 0 0 "Container startup failed"
    ctr t ls | grep 'nginx-container' | grep 'RUNNING'
    CHECK_RESULT $? 0 0 "Container not running"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    ctr task kill nginx-container
    ctr c rm nginx-container
    ctr images rm docker.io/library/nginx:latest
    ps -ef | grep -v 'grep' |grep 'containerd' |grep -v 'oe_test_containerd' |awk '{print $2}' | xargs -I {} kill -9 {}
    DNF_REMOVE
    LOG_INFO "Finish restoring the test environment."
}

main "$@"


