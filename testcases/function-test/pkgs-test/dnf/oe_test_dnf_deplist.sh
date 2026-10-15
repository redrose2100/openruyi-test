#!/usr/bin/bash

# Copyright (c) 2024. UnionTech Software Technology Co.,Ltd.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
###################################
#@Author        :   Lufei
#@Contact       :   lufei@uniontech.com
#@Date          :   2024/02/29
#@License       :   Mulan PSL v2
#@Desc          :   Test "dnf deplist" command
###################################

source "${OET_PATH}/testcases/function-test/pkgs-test/dnf/common/common_dnf.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    dnf list --available -q | grep -v "Available Packages" | awk '{print $1}' > pkg_list
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    pkg_name=$(shuf -n1 pkg_list)
    LOG_INFO "run: dnf deplist $pkg_name"
    dnf deplist "$pkg_name"
    CHECK_RESULT $? 0 0 "dnf deplist $pkg_name failed."
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf pkg_list
    LOG_INFO "End of restore the test environment."
}

main "$@"
