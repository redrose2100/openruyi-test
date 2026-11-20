#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2020/04/25
# @License   :   Mulan PSL v2
# @Desc      :   Vulnerability scanning system
# #############################################
# shellcheck disable=SC2034

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "scap-security-guide openscap"
    EXECUTE_T="60m"
    # DNF_INSTALL 只关注“包不存在”，其他安装失败（依赖冲突等）不会报错，
    # 后续 oscap 会以 127 command not found 暴雷，这里提前把真实原因说清楚。
    if ! command -v oscap >/dev/null 2>&1; then
        LOG_WARN "oscap is unavailable after installing scap-security-guide/openscap."
        LOG_WARN "The runner cannot provide oscap, skip this case."
        exit 255
    fi
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    oscap oval eval --report vulnerability.html /usr/share/xml/scap/ssg/content/ssg-ol7-oval.xml
    CHECK_RESULT $? 0 0 "exec 'oscap oval eval --report vulnerability.html /usr/share/xml/scap/ssg/content/ssg-ol7-oval.xml' failed"
    grep oscap vulnerability.html
    CHECK_RESULT $? 0 0 "oscap failed"
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    rm -rf vulnerability.html
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
