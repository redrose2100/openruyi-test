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
#@Desc      :   Test "cobbler mgmtclass" command
###################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start to run testcase."
    cobbler mgmtclass add --name=OpenEuler
    CHECK_RESULT $? 0 0 0 "Failed option: mgmtclass add"
    cobbler mgmtclass copy --name=OpenEuler --newname=newOpenEuler
    CHECK_RESULT $? 0 0 0 "Failed option: mgmtclass copy"
    cobbler mgmtclass edit --name=openEuler --owners=tom
    CHECK_RESULT $? 0 0 0 "Failed option: mgmtclass edit"
    cobbler mgmtclass list 2>&1 | grep "newOpenEuler"
    CHECK_RESULT $? 0 0 0 "Failed option: mgmtclass list"
    cobbler mgmtclass find 2>&1 | grep "OpenEuler"
    CHECK_RESULT $? 0 0 0 "Failed option: mgmtclass find"
    cobbler mgmtclass remove --name=OpenEuler
    CHECK_RESULT $? 0 0 0 "Failed option: mgmtclass remove"
    cobbler mgmtclass rename --name=newOpenEuler --newname=oldOpenEuler
    CHECK_RESULT $? 0 0 0 "Failed option: mgmtclass rename"
    cobbler mgmtclass report --name=oldOpenEuler 2>&1 | grep "Name"
    CHECK_RESULT $? 0 0 0 "Failed option: mgmtclass report"
    LOG_INFO "End to run testcase."
}

main "$@"
