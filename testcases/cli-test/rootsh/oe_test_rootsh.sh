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
#@Date      	:   2022-03-03 09:39:43
#@License   	:   Mulan PSL v2
#@Desc      	:   Test Command rootsh
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

# 测试对象、测试需要的工具等安装准备
function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    DNF_INSTALL "rootsh"

    LOG_INFO "End to prepare the test environment."
}

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."

#    # 测试命令：-?
#    LOG_INFO "Start to test rootsh -?."
#    rootsh -? 2>&1
#    CHECK_RESULT $? 0 1 "Failed option: -?"
#
#    # 测试命令：-V
#    rootsh -V 2>&1
#    CHECK_RESULT $? 0 1 "Failed option: -V"
#
#    # 测试命令：-i
#    export pid_Oldbash=$(ps | grep -E bash | awk '{print $1}') #获取原bash的进程id
#    rootsh -i 2>&1                                             #进入rootsh
#    local pid_Newbash=$(ps | grep -E bash | awk '{print $1}')  #获取新bash的进程id
#    if ((pid_Oldbash == pid_Newbash)); then
#        CHECK_RESULT 1 0 1 "Failed option: -i" #两个bash进程号相同说明rootsh没有成功启动一个新bash
#    fi
#    if (($(ls /var/log/rootsh | grep -vE '.closed$') != 0)); then
#        CHECK_RESULT 1 0 1 "Failed option: -i" #进到rootsh的bash后，会在/var/log/rootsh目录下产生结尾没有".closed"后缀的日志文件，如果没有则说明程序执行有问题
#    fi
#    exit #退出rootsh的bash
#    CHECK_RESULT $? 0 1 "Failed option: -i"
#
#    # 测试命令：-u
#    local user=yili
#    rootsh -u $user 2>&1
#    pid_Newbash=$(ps | grep -E bash | awk '{print $1}')
#    if ((pid_Oldbash == pid_Newbash)); then
#        CHECK_RESULT 1 0 1 "Failed option: -u" #两个bash进程号相同说明rootsh没有成功启动一个新bash
#    fi
#    if (($(ls /var/log/rootsh | grep -vE '.closed$') != 0)); then #查看当前bash的日志是否存在并且用户名和输入参数的用户名是否一致
#        CHECK_RESULT 1 0 1 "Failed option: -u"
#    fi
#    if (($(whoami | grep -E $user) != 0)); then
#        CHECK_RESULT 1 0 1 "Failed option: -u"
#    fi
#    exit
#    CHECK_RESULT $? 0 1 "Failed option: -u"
#
#    # 测试命令：-u 的错误输入测试
#    user=zhangsan #系统中没有zhangsan用户
#    rootsh -u $user 2>&1 | grep -E 'does not exist$'
#    if (($? == 1)); then
#        CHECK_RESULT 1 0 1 "Failed option: -u"
#    fi
#
#    # 测试命令：-f
#    rootsh -f yili_log 2>&1 #此命令会在该用户的家目录中新建日志文件yili_log
#    pid_Newbash=$(ps | grep -E bash | awk '{print $1}')
#    if ((pid_Oldbash == pid_Newbash)); then
#        CHECK_RESULT 1 0 1 "Failed option: -f" #两个bash进程号相同说明rootsh没有成功启动一个新bash
#    fi
#    if (($(ls | grep -E 'yili_log') != 0)); then
#        CHECK_RESULT 1 0 1 "Failed option: -f"
#    fi
#    exit
#    CHECK_RESULT $? 0 1 "Failed option: -f"
#
#    # 测试命令：-d
#    # 这里rootsh不会自己新建目录，需要自己建好目录后使用本命令，这里的目录: /my_log
#    rootsh -d /my_log
#    pid_Newbash=$(ps | grep -E bash | awk '{print $1}')
#    if ((pid_Oldbash == pid_Newbash)); then
#        CHECK_RESULT 1 0 1 "Failed option: -d" #两个bash进程号相同说明rootsh没有成功启动一个新bash
#    fi
#    if (($(ls /my_log | grep -vE '^root.closed$') != 0)); then
#        CHECK_RESULT 1 0 1 "Failed option: -d"
#    fi
#    exit
#    CHECK_RESULT $? 0 1 "Failed option: -d"
#
#    # 测试命令：--no-logfile
#    rootsh --no-logfile
#    pid_Newbash=$(ps | grep -E bash | awk '{print $1}')
#    if ((pid_Oldbash == pid_Newbash)); then
#        CHECK_RESULT 1 0 1 "Failed option: --no-logfile" #两个bash进程号相同说明rootsh没有成功启动一个新bash
#    fi
#    if (($(ls /var/log/rootsh | grep -vE '.closed') != 1)); then
#        CHECK_RESULT 0 1 1 "Failed option: --no-logfile" #进到rootsh的bash后，不会在/var/log/rootsh目录下产生结尾没有".closed"后缀的日志文件，如果有则说明程序执行有问题
#    fi
#    exit
#    CHECK_RESULT $? 0 1 "Failed option: --no-logfile"
#
#    # 测试命令：--no-syslog
#    rootsh --no-syslog
#    pid_Newbash=$(ps | grep -E bash | awk '{print $1}')
#    if ((pid_Oldbash == pid_Newbash)); then
#        CHECK_RESULT 1 0 1 "Failed option: --no-syslog" #两个bash进程号相同说明rootsh没有成功启动一个新bash
#    fi
#    if (($(ls /var/log/rootsh | grep -vE '.closed$') != 0)); then
#        CHECK_RESULT 1 0 1 "Failed option: --no-syslog" #进到rootsh的bash后，会在/var/log/rootsh目录下产生结尾没有".closed"后缀的日志文件，如果没有则说明程序执行有问题
#    fi
#    if (($(tail -n 1 /var/log/messages | awk '{print $5}' | grep -E 'rootsh') != 0)); then #第五列为执行的程序，不是rootsh说明没有在系统日志中记录
#        CHECK_RESULT 1 0 1 "Failed option: --no-syslog"
#    fi
#    exit
#    CHECK_RESULT $? 0 1 "Failed option: --no-syslog"

    LOG_INFO "End to run test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."

    DNF_REMOVE

    LOG_INFO "End to restore the test environment."
}

main "$@"
