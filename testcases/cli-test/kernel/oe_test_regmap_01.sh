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
# @Desc      :   kernel regmap module
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."
    kernel_name=$(uname -r)
    cd /usr/lib/modules/"${kernel_name}"/kernel/drivers/base/regmap || exit
    test -f regmap-i2c.ko.xz 
    CHECK_RESULT $? 0 0 "file does not exist"
    modprobe regmap-i2c
    CHECK_RESULT $? 0 0 "Information display failed"
    modinfo  regmap-i2c|grep vermagic
    CHECK_RESULT $? 0 0 "Module not loaded"
    lsmod | grep regmap_i2c
    CHECK_RESULT $? 0 0 "Module loaded failed"
    rmmod regmap_i2c
    CHECK_RESULT $? 0 0 "Module uninstall failed"
    lsmod | grep regmap_i2c
    CHECK_RESULT $? 1 0 "Module not loaded"

}
function post_test() {
    LOG_INFO "start environment cleanup."
    rmmod regmap-i2c 
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
