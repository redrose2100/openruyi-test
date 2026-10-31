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
# shellcheck disable=SC1090

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start executing testcase."
    if [ -d /etc/sysconfig/network-scripts ]; then
        cfg_dir=/etc/sysconfig/network-scripts
        find "$cfg_dir" -type f | grep ifcfg | head -n 1
        CHECK_RESULT $? 0 0 "have no available net cfg file"
        cfg01=$(find "$cfg_dir" -type f | grep ifcfg | head -n 1)
    elif [ -d /etc/NetworkManager/system-connections ]; then
        cfg_dir=/etc/NetworkManager/system-connections
        find "$cfg_dir" -type f | head -n 1
        CHECK_RESULT $? 0 0 "have no available net cfg file"
        cfg01=$(find "$cfg_dir" -type f | head -n 1)
    else
        exit 255
    fi
    if grep -q "^NAME=" "$cfg01"; then
        grep -i "^NAME=" "$cfg01"
        CHECK_RESULT $? 0 0 "the item is use for set net NAME"
        grep -i "^BOOTPROTO=" "$cfg01"
        CHECK_RESULT $? 0 0 "the item is use for set net bootproto"
        grep -i "^ONBOOT=" "$cfg01"
        CHECK_RESULT $? 0 0 "the item is use for set automatically connect to the network upon startup"
        grep -i "^DEVICE=" "$cfg01"
        CHECK_RESULT $? 0 0 "the item is use for set net name"
        if ! grep -i "^BOOTPROTO=dhcp" "$cfg01" && ping -c 3 www.baidu.com; then
            grep -i "^DEFROUTE=" "$cfg01"
            CHECK_RESULT $? 0 0 "the item is use for set default route"
        fi
    elif grep -q "^\[connection\]" "$cfg01"; then
        grep -i "^id=" "$cfg01"
        CHECK_RESULT $? 0 0 "the item is use for set net NAME"
        grep -i "^interface-name=" "$cfg01"
        CHECK_RESULT $? 0 0 "the item is use for set net name"
        grep -i "^method=" "$cfg01"
        CHECK_RESULT $? 0 0 "the item is use for set net bootproto"
        grep -i "^autoconnect=" "$cfg01"
        CHECK_RESULT $? 0 0 "the item is use for set automatically connect to the network upon startup"
        if grep -qi "^method=manual" "$cfg01" && ping -c 3 www.baidu.com; then
            grep -i "^never-default=" "$cfg01"
            CHECK_RESULT $? 0 0 "the item is use for set default route"
        fi
    else
        CHECK_RESULT 1 0 0 "unrecognized net cfg file format"
    fi
    LOG_INFO "End of testcase execution."
}

main "$@"
