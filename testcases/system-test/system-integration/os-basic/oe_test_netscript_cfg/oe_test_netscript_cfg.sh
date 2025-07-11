#!/usr/bin/bash

#Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   wenqiongjie
# @Contact   :   wenqiongjie@uniontech.com
# @Date      :   2024-03-21
# @License   :   Mulan PSL v2
# @Desc      :   network cfg file test
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start executing testcase."
    find /etc/sysconfig/network-scripts/ -type f | head -n 1 | grep ifcfg
    CHECK_RESULT $? 0 0 "have no available net cfg file"
    cfg01=$(find /etc/sysconfig/network-scripts/ -type f | head -n 1 | grep ifcfg)
    grep -i type "$cfg01"
    CHECK_RESULT $? 0 0 "the item is use for set net type"
    grep -i bootproto "$cfg01"
    CHECK_RESULT $? 0 0 "the item is use for set net bootproto"
    grep -i onboot "$cfg01"
    CHECK_RESULT $? 0 0 "the item is use for set automatically connect to the network upon startup"
    grep -i device "$cfg01"
    CHECK_RESULT $? 0 0 "the item is use for set net name"
    if ! grep dhcp "$cfg01" && ping -c 3 www.baidu.com; then
        grep -i defroute "$cfg01"
        CHECK_RESULT $? 0 0 "the item is use for set default route"
    fi
    LOG_INFO "End of testcase execution."
}

main "$@"
