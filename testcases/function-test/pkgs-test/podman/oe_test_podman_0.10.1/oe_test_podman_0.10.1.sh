#!/usr/bin/bash

#Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   chengweibin
# @Contact   :   chengweibin@uniontech.com
# @Date      :   2023-08-18
# @License   :   Mulan PSL v2
# @Desc      :   test podman command
# ############################################
# shellcheck disable=SC1091,SC2119

source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "../common/versioncheck.sh"


function pre_test() {
    version_check
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "podman podman-docker"
    cat >> /etc/containers/registries.conf << EOF
[registries.search]
registries = ["docker.io"]
EOF
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    version_check
    LOG_INFO "Start testing..."
    podman --help | grep "USAGE:"
    CHECK_RESULT $? 0 0 "podman  -help failed"
    podman version |grep '[0-9]'
    CHECK_RESULT $? 0 0 "podman failed"
    podman info | grep "docker.io"
    CHECK_RESULT $? 0 0 "podman info failed"
    podman images
    CHECK_RESULT $? 0 0 "podman images failed"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -f /etc/containers/registries.conf
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
