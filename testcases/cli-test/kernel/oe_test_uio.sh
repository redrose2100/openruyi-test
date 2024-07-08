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
# @Date      :   2024/03/13
# @License   :   Mulan PSL v2
# @Desc      :   Huawei uio module
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."
    kernel_name=$(uname -r)
    mod_name=uio
    test -f /usr/lib/modules/"${kernel_name}"/kernel/drivers/uio/uio.ko.xz
    CHECK_RESULT $? 0 0 "file does not exist"
    modinfo uio |grep -i version
    CHECK_RESULT $? 0 0 "Information display failed"
    modprobe uio
    CHECK_RESULT $? 0 0 "Module not loaded"
    lsmod | grep uio
    CHECK_RESULT $? 0 0 "Module loaded failed"
    if [ "$(modprobe --version | grep version | awk '{print $3}')" -gt "29" ]; then
        modprobe -r --remove-holders "${mod_name}"
        CHECK_RESULT $? 0 0 "Module uninstall failed"
    else
        modprobe -r "${mod_name}"
        CHECK_RESULT $? 0 0 "Module uninstall failed"
    fi   
    CHECK_RESULT $? 0 0 "Module uninstall failed"
    lsmod | grep uio
    CHECK_RESULT $? 1 0 "Module loaded"

}
function post_test() {
    LOG_INFO "start environment cleanup."
    if [ "$(modprobe --version | grep version | awk '{print $3}')" -gt "29" ]; then
        modprobe -r --remove-holders "${mod_name}"
    else
        modprobe -r "${mod_name}"
    fi
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
