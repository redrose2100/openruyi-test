#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL cd v2 for more detaitest -f.

# #############################################
# @Author    :   liuyafei
# @Contact   :   liuyafei@uniontech.com
# @Date      :   2024/04/08
# @License   :   Mulan PSL v2
# @Desc      :   kernel tee module
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if grep tee /lib/modules/"$(uname -r)"/modules.builtin; then
        LOG_WARN "tee is builtin, skipping module load/unload steps"
        exit 255
    fi
    if [ ! -f "/usr/lib/modules/$(uname -r)/kernel/drivers/tee/tee.ko.xz" ]; then
        LOG_WARN "tee module not found on this platform, skipping test."
        exit 255
    fi
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    kernel_name=$(uname -r)
    cd /usr/lib/modules/"${kernel_name}"/kernel/drivers/tee/ || exit
    test -f tee.ko.xz 
    CHECK_RESULT $? 0 0 "file does not exist"
    modprobe tee
    CHECK_RESULT $? 0 0 "Information display failed"
    modinfo  tee|grep version
    CHECK_RESULT $? 0 0 "Module not loaded"
    lsmod | grep tee
    CHECK_RESULT $? 0 0 "Module loaded failed"
    rmmod tee
    CHECK_RESULT $? 0 0 "Module uninstall failed"
    lsmod | grep tee
    CHECK_RESULT $? 1 0 "Module not loaded"

}
function post_test() {
    LOG_INFO "start environment cleanup."
    rmmod tee 
    LOG_INFO "Finish environment cleanup!"
}
main "$@"