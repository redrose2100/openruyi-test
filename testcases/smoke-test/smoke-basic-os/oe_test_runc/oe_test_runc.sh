#!/usr/bin/bash

# Copyright (c) 2021 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   geyaning
# @Contact   :   geyaning@uniontech.com
# @Date      :   2022-11-30
# @License   :   Mulan PSL v2
# @Desc      :   runc-package test 
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "docker-runc"
    mkdir -p /opt/runctest/
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    cd /opt/runctest
    mkdir rootfs
    cp -ap /bin/ rootfs/
    cp -ap /lib/ rootfs/
    cp -ap /lib64/ rootfs/
    runc spec
    CHECK_RESULT $? 0 0 "Unable to generate config.json file"
    sed -i '/terminal/s|true|false|' config.json
    sed -i '/"sh"/s|"sh"|"sleep", "50"|' config.json
    runc run -d mycontainer
    runc list | grep mycontainer
    CHECK_RESULT $? 0 0 "Container creation failure"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf /opt/runctest
    LOG_INFO "Finish environment cleanup!"
}

main $@
