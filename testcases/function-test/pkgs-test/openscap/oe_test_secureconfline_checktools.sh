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
# @Author    :   maojintao
# @Contact   :   mjt1220@126.com
# @Date      :   2023/07/26
# @License   :   Mulan PSL v2
# @Desc      :   openEuler安全配置规范基线检查工具测试
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "${OET_PATH}/testcases/function-test/pkgs-test/openscap/common.sh"

# 测试对象、测试需要的工具等安装准备
function pre_test() {
    dnf install -y openscap
    dnf install -y scap-security-guide
}

# 测试点的执行
function run_test() {
    command -v oscap || oe_err "oscap cmd check failed"
    oscap xccdf eval --profile xccdf_org.ssgproject.content_profile_standard --results scan_results.xml --report scan_report.html /usr/share/xml/scap/ssg/content/ssg-openeuler2203-ds.xml \
        || oe_err "tool exec failed, please check"
    test -f ./scan_report.html || oe_err "scan_report.html not found"
    test -f ./scan_results.xml || oe_err "scan_results.xml not found"
}

# 后置处理，恢复测试环境
function post_test() {
    dnf remove -y openscap scap-security-guide
}

main "$@"
