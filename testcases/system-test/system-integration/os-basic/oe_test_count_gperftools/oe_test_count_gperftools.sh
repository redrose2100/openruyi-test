#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   xiongneng
# @Contact   :   xiongneng@uniontech.com
# @Date      :   2023/04/04
# @License   :   Mulan PSL v2
# @Desc      :   Test gperftools-安装卸载
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start testing..."
    yum list gperftools
    CHECK_RESULT $? 0 0 "Failed to query software package"
    rpm -qa |grep gperftools
    CHECK_RESULT $? 0 1 "Detection software package installed"
    DNF_INSTALL "gperftools"
    CHECK_RESULT $? 0 0 "Software package installation failed"
    rpm -qa |grep gperftools
    CHECK_RESULT $? 0 0 "Software package not installed"
    DNF_REMOVE
    rpm -qa |grep gperftools
    CHECK_RESULT $? 0 1 "Software package not uninstalled"
    LOG_INFO "Finish test!"
}

main "$@"