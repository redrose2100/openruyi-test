#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   huangrong
# @Contact   :   1820463064@qq.com
# @Date      :   2020/10/23
# @License   :   Mulan PSL v2
# @Desc      :   Test cachefilesd.service restart
# #############################################
# shellcheck disable=SC2119
source "$OET_PATH/testcases/cli-test/common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL cachefilesd
    # 软件自带的配置文件 /etc/cachefilesd.conf 启用了selinux的设置：secctx system_u:system_r:cachefiles_kernel_t:s0，环境中未启动SELinux时，注释掉该行
    if grep -q "^SELINUX=disabled" /etc/selinux/config; then
       sudo sed -i.bak 's/^[[:space:]]*secctx/#&/' /etc/cachefilesd.conf
    fi
    LOG_INFO "End of environmental preparation!"
}


function run_test() {
    LOG_INFO "Start testing..."
    test_execution cachefilesd.service
    test_reload cachefilesd.service
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    #环境中未启动SELinux时，恢复配置文件/etc/cachefilesd.conf内容
    if grep -q "^SELINUX=disabled" /etc/selinux/config; then
       sudo sed -i 's/^#[[:space:]]*\(secctx.*\)/\1/' /etc/cachefilesd.conf
    fi
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
