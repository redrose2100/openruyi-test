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
# @Desc      :   verify the uasge of libguestfs virt-v2v command
# ############################################
# shellcheck disable=SC2119

source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "${OET_PATH}/testcases/cli-test/libguestfs/common/checkenv.sh"


function pre_test() {
    # libguestfs 1.42版本后不再支持virt-v2v, virt-p2v and the boot analysis tools 命令工具
    checkversion142
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL 'libguestfs virt-manager'
    LOG_INFO "End of environmental preparation!"
}


function run_test() {
    LOG_INFO "Start to run test."
    virt-v2v --help 2>&1 | grep 'virt-v2v'
    CHECK_RESULT $? 0 0 "Check virt-v2v --help failed"
    virt-v2v -V | grep "$(rpm -q libguestfs --queryformat '%{version}\n')"
    CHECK_RESULT $? 0 0 "Check virt-copy-in -V failed"
    LOG_INFO "End of the test."
}


function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "Finish to restore the test environment."
}


main "$@"
