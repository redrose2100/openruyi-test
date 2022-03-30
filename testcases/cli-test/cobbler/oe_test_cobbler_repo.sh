#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

###################################
#@Author    :   qinhaiqi
#@Contact   :   2683064908@qq.com
#@Date      :   2022/2/16
#@License   :   Mulan PSL v2
#@Desc      :   Test "cobbler repo" command
###################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL cobbler httpd
    systemctl start httpd
    systemctl start cobblerd
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run testcase."
    cobbler repo add --name=OpenEuler --mirror=/etc/yum.repos.d/openEuler.repo
    CHECK_RESULT $? 0 0 0 "Failed option: repo add"
    cobbler repo copy --name=OpenEuler --newname=newOpenEuler
    CHECK_RESULT $? 0 0 0 "Failed option: repo copy"
    cobbler repo edit --name=openEuler --owners=tom
    CHECK_RESULT $? 0 0 0 "Failed option: repo edit"
    cobbler repo list 2>&1 | grep "newOpenEuler"
    CHECK_RESULT $? 0 0 0 "Failed option: repo list"
    cobbler repo find 2>&1 | grep "OpenEuler"
    CHECK_RESULT $? 0 0 0 "Failed option: repo find"
    cobbler repo remove --name=OpenEuler
    CHECK_RESULT $? 0 0 0 "Failed option: repo remove"
    cobbler repo rename --name=newOpenEuler --newname=oldOpenEuler
    CHECK_RESULT $? 0 0 0 "Failed option: repo rename"
    cobbler repo report --name=oldOpenEuler 2>&1 | grep "Name"
    CHECK_RESULT $? 0 0 0 "Failed option: repo report"
    LOG_INFO "End to run testcase."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl stop httpd
    systemctl stop cobblerd
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
