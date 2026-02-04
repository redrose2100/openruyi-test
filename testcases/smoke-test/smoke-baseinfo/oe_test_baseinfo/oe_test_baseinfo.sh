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
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2022/04/19
# @License   :   Mulan PSL v2
# @Desc      :   Basic information of test system
# ############################################
# shellcheck disable=SC1090

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    free | grep -i mem -A 1 | grep -i swap
    CHECK_RESULT $? 0 0 "Failed command: free"
    lscpu | grep -iE "Arch|cpu"
    CHECK_RESULT $? 0 0 "Failed command: lscpu"
    fdisk -l | grep -iE "disk|dev"
    CHECK_RESULT $? 0 0 "Failed command: fdisk"
    if [ "${NODE1_OS_VERSION}" == "debian" ];then
        grep -iE "name|version|ID" /etc/os-release | grep debian
        CHECK_RESULT $? 0 0 "/etc/os-release file view failed"
    elif [ "${NODE1_OS_VERSION}" == "openEuler" ];then
        grep -iE "name|version|ID" /etc/os-release | grep openEuler
        CHECK_RESULT $? 0 0 "/etc/os-release file view failed"
    fi
    if ! df -h / |grep overlay; then
        timedatectl set-timezone Asia/Shanghai
	old_zone=$(timedatectl | grep "Time zone" | awk '{print $3}')
        timedatectl | grep "$(date | awk '{print$1}')"
        CHECK_RESULT $? 0 0 "Failed command: timedatectl"
        timedatectl list-timezones | grep Tokyo
        CHECK_RESULT $? 0 0 "Time zone information display failed"
        timedatectl | grep Tokyo
        CHECK_RESULT $? 1 0 "The time zone is Tokyo"
        timedatectl set-timezone Asia/Tokyo
        CHECK_RESULT $? 0 0 "Failed to set time zone"
        timedatectl | grep Tokyo
        CHECK_RESULT $? 0 0 "The time zone isn't Tokyo"
        timedatectl set-timezone "$old_zone"
        CHECK_RESULT $? 0 0 "Failed to recover time zone"
        localectl status | grep -i "System Locale"
        CHECK_RESULT $? 0 0 "The system language does not belong to us"
        if [ "${NODE1_OS_VERSION}" == "debian" ];then
            localectl list-locales | grep en
            CHECK_RESULT $? 0 0 "The system language does not contain English"
            cp /etc/locale.gen /etc/locale.gen_bak
            sed -i "s/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/g" /etc/locale.gen
            locale-gen
        else
            localectl list-locales | grep zh
            CHECK_RESULT $? 0 0 "The system language does not contain Chinese"
        fi
        localectl set-locale LANG=zh_CN.utf8
        CHECK_RESULT $? 0 0 "Failed to set Chinese"
        localectl status | grep zh_CN.utf8
        CHECK_RESULT $? 0 0 "The system language isn't Chinese"
        localectl set-locale LANG=en_US.UTF-8
        CHECK_RESULT $? 0 0 "Failed to set English"
        localectl status | grep en_US.UTF-8
        CHECK_RESULT $? 0 0 "The system language isn't English"
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    if [ "${NODE1_OS_VERSION}" == "debian" ];then
        mv -f /etc/locale.gen_bak /etc/locale.gen
        locale-gen
    fi
    export LANG=${OLD_LANG}
    LOG_INFO "End to restore the test environment."
}

main "$@"
