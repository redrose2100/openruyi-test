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
# @Author    :   huike
# @Contact   :   754873891@qq.com
# @Date      :   2023/03/02
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of libguestfs virt-index-validate command
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    version_id=$(grep "VERSION_ID" /etc/os-release | awk -F "=" '{print $NF}' | awk -F "\"" '{print $2}')
    if [[ ${version_id} != "20.03" && ${version_id} != "22.03" ]];then
        DNF_INSTALL guestfs-tools
    else
        DNF_INSTALL 'libguestfs virt-manager'
    fi
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    virt-index-validate --help 2>&1 | grep 'virt-index-validate'
    CHECK_RESULT $? 0 0 "Check virt-index-validate --help failed"
    if [[ ${version_id} != "20.03" && ${version_id} != "22.03" ]];then
        virt-index-validate -V | grep "$(rpm -q guestfs-tools --queryformat '%{version}\n')"
    else
        virt-index-validate -V | grep "$(rpm -q libguestfs --queryformat '%{version}\n')"
    fi
    CHECK_RESULT $? 0 0 "Check virt-index-validate -V failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "Finish to restore the test environment."
}

main "$@"
