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
#@Desc      :   Test "cobbler file" command
###################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    touch test.txt
    DNF_INSTALL cobbler httpd
    systemctl start httpd
    systemctl start cobblerd
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run testcase."
    cobbler file add --name=OpenEuler --path=test.txt --owner=root --group=root --mode=mode --template=tem
    CHECK_RESULT $? 0 0 0 "Failed option: file add"
    cobbler file copy --name=OpenEuler --newname=newOpenEuler
    CHECK_RESULT $? 0 0 0 "Failed option: file copy"
    cobbler file edit --name=openEuler --owners=tom
    CHECK_RESULT $? 0 0 0 "Failed option: file edit"
    cobbler file list 2>&1 | grep "newOpenEuler"
    CHECK_RESULT $? 0 0 0 "Failed option: file list"
    cobbler file find 2>&1 | grep "OpenEuler"
    CHECK_RESULT $? 0 0 0 "Failed option: file find"
    cobbler file remove --name=OpenEuler
    CHECK_RESULT $? 0 0 0 "Failed option: file remove"
    cobbler file rename --name=newOpenEuler --newname=oldOpenEuler
    CHECK_RESULT $? 0 0 0 "Failed option: file rename"
    cobbler file report --name=oldOpenEuler 2>&1 | grep "Name"
    CHECK_RESULT $? 0 0 0 "Failed option: file report"
    LOG_INFO "End to run testcase."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm test.txt
    systemctl stop httpd
    systemctl stop cobblerd
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
