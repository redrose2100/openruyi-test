#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huyahui
# @Contact   :   huyahui8@163.com
# @modify    :   wangxiaoya@qq.com
# @Date      :   2022/05/09
# @License   :   Mulan PSL v2
# @Desc      :   View configuration files to ensure security compliance
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    if [[ "$(uname -m)" == "riscv64" ]]; then
        DNF_INSTALL "python3-paramiko"
    fi
    DNF_INSTALL "openscap scap-security-guide"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    for file in /usr/share/xml/scap/ssg/content/*.xml; do
        echo "$file"
    done
    CHECK_RESULT $?
    oscap info /usr/share/xml/scap/ssg/content/ssg-ol7-ds.xml | grep Ref-Id
    CHECK_RESULT $?
    latest_sl_file=$(find /usr/share/xml/scap/ssg/content -name 'ssg-sl[0-9]*-xccdf.xml' -print0 | sort -z -V | tail -z -n 1 | tr -d '\0')
    oscap info --profile pci-dss "$latest_sl_file" | grep pci-dss
    CHECK_RESULT $?
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
