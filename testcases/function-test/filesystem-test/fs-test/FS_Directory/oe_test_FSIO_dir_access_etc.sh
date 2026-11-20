#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.All rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   @meitingli
#@Contact   	:   bubble_mt@outlook.com
#@Date      	:   2020-11-19
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test access of /etc
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
# 发行版信息兼容层：用于判断 /etc 下的发行版标识文件是否应当存在。
source ${OET_PATH}/libs/locallibs/os_release_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    ls -l /etc | grep kernel | grep -q drwxr-xr-x
    CHECK_RESULT $? 0 0 "The kernel on /etc has some errors."
    # openEuler-latest 只在 openEuler 系镜像上存在，衍生发行版用 /etc/os-release 等价校验。
    if [ -n "${OS_RELEASE_LATEST_FILE}" ]; then
        ls -l /etc | grep openEuler-latest | grep -q "\-r--r--r--"
        CHECK_RESULT $? 0 0 "The openEuler-latest on /etc has some errors."
    else
        # 某些发行版把 /etc/os-release 做成指向 /usr/lib/os-release 的软链接，
        # 用 ls -lL 跟随链接后再校验真实文件权限。
        ls -lL /etc/os-release | grep -q "\-rw-r--r--"
        CHECK_RESULT $? 0 0 "The os-release on /etc has some errors."
    fi
    # openEuler_security 是 openEuler 专有目录，衍生发行版上存在与否都正常。
    if [ -d /etc/openEuler_security ]; then
        ls -l /etc | grep openEuler_security | grep -q drwx------
        CHECK_RESULT $? 0 0 "The openEuler_security on /etc has some errors."
    else
        LOG_INFO "/etc/openEuler_security is not present on this distribution, skipped."
    fi
    ls -l /etc | grep sudoers | grep -q "\-r--r-----"
    CHECK_RESULT $? 0 0 "The sudoers on /etc has some errors."
    ls -l /etc | grep systemd | grep -q drwxr-xr-x
    CHECK_RESULT $? 0 0 "The systemd on /etc has some errors."
    dir1=('bashrc' 'environment' 'filesystems' 'networks')
    # openEuler-release 只在 openEuler 系镜像上存在。
    if [ -n "${OS_RELEASE_RELEASE_FILE}" ]; then
        dir1+=('openEuler-release')
    fi
    for i in $(seq 0 $((${#dir1[@]} - 1))); do
        ls -l /etc | grep -w "${dir1[$i]}" | grep -q "\-rw-r--r--"
        CHECK_RESULT $? 0 0 "The access of /${dir1[$i]} is false."
    done
    LOG_INFO "End to run test."
}

main "$@"

