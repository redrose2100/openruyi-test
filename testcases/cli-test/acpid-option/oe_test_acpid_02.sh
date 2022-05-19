#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   zhangyili2
#@Contact   	:   yili@isrc.iscas.ac.cn
#@Date      	:   2022-05-19 09:39:43
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test for pax
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

# 需要预加载的数据、参数配置
function config_params() {
    LOG_INFO "Start to config params of the case."

    LOG_INFO "No params need to config."

    LOG_INFO "End to config params of the case."
}

# 测试对象、测试需要的工具等安装准备
function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    DNF_INSTALL "acpid"
    DNF_INSTALL "nc"

    LOG_INFO "End to prepare the test environment."
}

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."

    ! acpid --version 2>&1 | grep "invalid option" && acpid --version 2>&1 | grep "acpid-"
    CHECK_RESULT $? 0 0 "Failed option: --version"

    ! acpid --help 2>&1 | grep "invalid option" && acpid --help 2>&1 | grep "Usage: acpid"
    CHECK_RESULT $? 0 0 "Failed option: --help"

    acpid --foreground | grep "starting up with netlink and the input layer"
    CHECK_RESULT $? 0 0 "Falied option: --foreground"

    #-f默认是关闭log的，如果开启-l，则会开启log
    acpid --foreground | grep "event logging is off"
    CHECK_RESULT $? 0 0 "Failed option: --logevents"
    acpid --foreground --logevents | grep "event logging is on"
    CHECK_RESULT $? 0 0 "Failed option: --logevents"

    acpid --foreground --debug | grep "Deprecated /proc/acpi/event was not found.  Trying netlink and the input layer..."
    CHECK_RESULT $? 0 0 "Failed option: --debug"

    # -n选项不会寻找/proc/acpi/event下的事件，直接从网络层和内核输入开始，
    #因此不会有上一行的"Deprecated /proc/acpi/event was not found.  Trying netlink and the input layer..."
    #若出现，表示此选项有问题
    acpid --foreground --debug --netlink | grep "Deprecated /proc/acpi/event was not found.  Trying netlink and the input layer..."
    CHECK_RESULT $? 0 1 "Falied option: --netlink"

    #-g这里替换成本地的组名
    ls -al /var/run/ | grep "acpid.socket" | grep "root"
    CHECK_RESULT $? 0 0 "Failed option: --socketgroup"
    acpid --socketgroup yili ##这替换存在的组,我这里是yili
    ls -al /var/run/ | grep "acpid.socket" | grep "yili"
    CHECK_RESULT $? 0 0 "Failed option: --socketgroup"
    acpid -g root ##恢复现场
    
    #-m, 默认权限是0666，
    ls -al /var/run/ | grep "acpid.socket" | grep "srw-rw-rw-"
    CHECK_RESULT $? 0 0 "Failed option: --socketmode"
    acpid --socketmode 0777 
    ls -al /var/run/ | grep "acpid.socket" | grep "srwxrwxrwx"
    CHECK_RESULT $? 0 0 "Failed option: --socketmode"
    acpid -m 0666 #恢复现场


    #-p默认生成的是/var/run/acpid.pid
    acpid --pidfile /var/run/acpid.test.pid
    acpid -m 0777
    ls -al /var/run/ | grep "acpid.test.pid"
    CHECK_RESULT $? 0 0 "Failed option: --pidfile"
    acpid -m 0666
    rm -f /var/run/acpid.test.pid


    LOG_INFO "End to run test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."

    DNF_REMOVE

    LOG_INFO "End to restore the test environment."
}

main "$@"
