#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   shidongdong
# @Contact   :   1220713556@qq.com
# @Date      :   2023/02/01
# @License   :   Mulan PSL v2
# @Desc      :   etmem common function
# #############################################

source "../../common/common_lib.sh"

#修改配置文件参数
function change_config_file_param() {
    param=$1
    param_value=$2
    file_name=$3
    sed -i "s/${param}=.*/${param}=${param_value}/g" "${file_name}"
}

# config etmem running env
function config_etmem_env() {
    local pid=0
    local syslog_time=0
    # 清理环境，干掉测试用例之外所有包含etmem的进程
    ps aux | grep -v grep | grep -v oe_test | grep etmemd | awk '{print $2}' | xargs kill -9
    rpm -qa | grep -w etmem || DNF_INSTALL etmem

    lsmod | grep etmem_scan || modprobe etmem_scan
    lsmod | grep etmem_swap || modprobe etmem_swap

    ls /usr/lib/systemd/system/etmemd.service
    if [ $? -eq 0 ]; then
        systemctl stop etmemd
        rm -rf /usr/lib/systemd/system/etmemd.service
    fi
    cp ../etmem_common/etmemd.service /usr/lib/systemd/system/
    cat /usr/lib/systemd/system/etmemd.service

    systemctl daemon-reload

    #普通进程就使用sshd
    sshdpid=$(systemctl status sshd | grep -v grep | grep "Main PID:" | awk '{print $3}')
    change_config_file_param name sshd ../etmem_common/config_slide_task.yaml
    change_config_file_param value "${sshdpid}" ../etmem_common/config_slide_task.yaml

    # 因为要不断重启rsyslogd服务，部分用例执行时间短，重启rsyslogd比较频繁，使rsyslogd状态异常
    while [ 1 ]; do
        ps aux | grep -v grep | grep -v oe_test | grep rsyslog
        if [ $? -eq 0 ]; then
            pid=$(ps aux | grep -v grep | grep -v oe_test | grep rsyslog | awk '{print $2}')
            break
        elif [ ${syslog_time} -lt 120 ]; then
            sleep 1
            ((syslog_time++))
        else
            exit 1 #rsyslog 2分钟没有起来，默认失败退出
        fi
    done
}

#等待要启动的进程，$1为要等待的进程名 $2为启动的进程数量，$2为可选入参
function wait_fun_start() {
    fun_name=$1
    local wait_times=1
    while [ 1 ]; do
        ps aux | grep -v grep | grep -v oe_test_etmem | grep "${fun_name}"
        if [ $? -eq 0 ]; then
            RETURN_FLAG=0
            if [ $# -ne 1 ]; then #如果参数总数不是1 说明有两个参数，需要找进程出现的个数
                local fun_num=$2
                local time_times=0
                while [ 1 ]; do #并发进程启动需要一个时间段，这个循环是等待所有并发进程启动，超时时间5秒
                    fun_num=$(ps aux | grep -v grep | grep -v oe_test | grep "${fun_name}" | wc -l)
                    if [ "${fun_num}" -ne "${fun_num}" -a "${time_times}" -lt 100 ]; then #数量不相等，且没有超出次数，sleep 0.1
                        ((time_times++))
                        sleep 0.1
                    elif [ "${time_times}" -gt 100 ]; then #无论数量等不等，超出次数，返回失败
                        RETURN_FLAG=1
                        exit 1
                    else #数量相等，直接break，返回成功
                        break
                    fi
                done
            fi
            return "${RETURN_FLAG}"
        else
            #server 1秒起不来就返回失败
            if [ "${wait_times}" -gt 30 ]; then
                LOG_INFO "$1 is error ,return"
                RETURN_FLAG=1
                return "${RETURN_FLAG}"
            else
                LOG_INFO "$1 is not up ,wait 0.1"
                sleep 0.1
                ((wait_times++))
            fi
        fi
    done
}

#启动etmemd，跟参数,参数-s以及-l
function get_up_etmemd() {
    etmemd_sock=$1
    etmemd_level=$2
    /usr/bin/etmemd -s "${etmemd_sock}" -l "${etmemd_level}" &
}

# etmem add project
function etmem_add_project() {
    project_name=$1
    add_project_sock=$2
    /usr/bin/etmem obj add -f "${project_name}" -s "${add_project_sock}"
    [[ $? -ne 0 ]] && return 1
    return 0
}

# etmem add engine
function etmem_add_slide_engine() {
    slide_engine_name=$1
    add_slide_engine_sock=$2
    /usr/bin/etmem obj add -f "${slide_engine_name}" -s "${add_slide_engine_sock}"
    [[ $? -ne 0 ]] && return 1
    return 0
}

#etmem add task
function etmem_add_slide_task() {
    slide_task_name=$1
    slide_add_task_sock=$2
    /usr/bin/etmem obj add -f "${slide_task_name}" -s "${slide_add_task_sock}"
    [[ $? -ne 0 ]] && return 1
    return 0
}

#etmem start project,
function etmem_start_project() {
    start_name=$1
    start_sock=$2
    /usr/bin/etmem project start -n "${start_name}" -s "${start_sock}"
    [[ $? -ne 0 ]] && return 1
    return 0
}

#etmem stop project,
function etmem_stop_project() {
    stop_name=$1
    stop_sock=$2
    /usr/bin/etmem project stop -n "${stop_name}" -s "${stop_sock}"
    [[ $? -ne 0 ]] && return 1
    return 0
}

#etmem del project
function etmem_del_slide_task() {
    del_slide_task_name=$1
    del_slide_task_sock=$2

    /usr/bin/etmem obj del -f "${del_slide_task_name}" -s "${del_slide_task_sock}"
    [[ $? -ne 0 ]] && return 1
    return 0
}

#etmem del engine
function etmem_del_slide_engine() {
    del_slide_engine_name=$1
    del_slide_engine_sock=$2

    /usr/bin/etmem obj del -f "${del_slide_engine_name}" -s "${del_slide_engine_sock}"
    [[ $? -ne 0 ]] && return 1
    return 0
}

#etmem del project
function etmem_del_project() {
    project_name=$1
    del_project_sock=$2
    /usr/bin/etmem obj del -f "${project_name}" -s "${del_project_sock}"
    [[ $? -ne 0 ]] && return 1
    return 0
}

#etmem show project
function etmem_show_project() {
    show_name=$1
    show_sock=$2
    /usr/bin/etmem project show -n "${show_name}" -s "${show_sock}"
    [[ $? -ne 0 ]] && return 1
    return 0
}

function get_up_service() {
    ls /usr/lib/systemd/system/etmemd.service
    [[ $? -ne 0 ]] && cp ../etmem_common/etmemd.service /usr/lib/systemd/system/
    systemctl daemon-reload
    systemctl restart etmemd
    [[ $? -ne 0 ]] && return 1
    return 0
}
