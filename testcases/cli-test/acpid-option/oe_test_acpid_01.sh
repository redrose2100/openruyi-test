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
#@Desc      	:   Take the test for acpid-option
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh


# 测试对象、测试需要的工具等安装准备
function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    DNF_INSTALL "acpid"
    DNF_INSTALL "nc" #用来生成套接字测试-s选项

    LOG_INFO "End to prepare the test environment."
}

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."

    ! acpid -v 2>&1 | grep "invalid option" && acpid -v 2>&1 | grep "acpid-"
    CHECK_RESULT $? 0 0 "Failed option: -v"

    ! acpid -h 2>&1 | grep "invalid option" && acpid -h 2>&1 | grep "Usage: acpid"
    CHECK_RESULT $? 0 0 "Failed option: -h"

    expect <<EOF
        spawn acpid -f
        expect "*starting up with netlink and the input layer*" {
            send "\003"
            expect eof {
                catch wait result
                exit [lindex \$result 3]
            }
        }
        exit 1
EOF
    CHECK_RESULT $? 0 0 "Failed option: -f"

    #-f默认是关闭log的，如果开启-l，则会开启log
    expect <<EOF
        spawn acpid -lf
        expect "*event logging is on*" {
            send "\003"
            expect eof {
                catch wait result
                exit [lindex \$result 3]
            }
        }
        exit 1
EOF
    CHECK_RESULT $? 0 0 "Failed option: -l"

    # -d选项默认会显示Deprecated /proc/acpi/event was not found
    expect <<EOF
        spawn acpid -df
        expect "*Deprecated /proc/acpi/event was not found.*" {
            send "\003"
            expect eof {
                catch wait result
                exit [lindex \$result 3]
            }
        }
        exit 1
EOF
    CHECK_RESULT $? 0 0 "Failed option: -d"

    # -n选项不会寻找/proc/acpi/event下的事件，直接从网络层和内核输入开始，
    #因此不会有上一行的"Deprecated /proc/acpi/event was not found.  Trying netlink and the input layer..."
    #若出现，表示此选项有问题
    expect <<EOF
        spawn acpid -ndf
        expect "*Deprecated /proc/acpi/event was not found.*" {
            send "\003"
            expect eof {
                catch wait result
                exit [lindex \$result 3]
            }
        }
        exit 9
EOF
    CHECK_RESULT $? 9 0 "Falied option: -n"


    #-g这里替换成本地的组名, 本来路径应该是/var/run的，但是/var/run是/run的符号链接,因此直接用/run
    ls -al /run/ | grep "acpid.socket" | grep "root"
    CHECK_RESULT $? 0 0 "Failed option: -g"
    acpid -g yili 
    sleep 1
    ls -al /run/ | grep "acpid.socket" | grep "yili"
    CHECK_RESULT $? 0 0 "Failed option: -g"
    acpid -g root ##恢复现场
    sleep 1

    #-m, 默认权限是0666，
    ls -al /run/ | grep "acpid.socket" | grep "srw-rw-rw-" 
    CHECK_RESULT $? 0 0 "Failed option: -m"
    acpid -m 0777
    sleep 1
    ls -al /run/ | grep "acpid.socket" | grep "srwxrwxrwx"
    CHECK_RESULT $? 0 0 "Failed option: -m"
    acpid -m 0666 #恢复现场
    sleep 1

    #-p默认生成的是/var/run/acpid.pid
    acpid -p /run/acpid.test.pid
    ls -al /run/ | grep "acpid.test.pid" 
    CHECK_RESULT $? 0 0 "Failed option: -p"
    rm -f /run/acpid.test.pid #恢复现场


    LOG_INFO "End to run test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."

    DNF_REMOVE

    LOG_INFO "End to restore the test environment."
}

main "$@"
