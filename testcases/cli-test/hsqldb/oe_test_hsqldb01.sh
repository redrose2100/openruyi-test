#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   yangxi
# @Contact   :   692819917@qq.com
# @Date      :   2025/09/12
# @License   :   Mulan PSL v2
# @Desc      :   Test hsqldb
# #############################################


source "${OET_PATH}/libs/locallibs/common_lib.sh"


function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL hsqldb
    systemctl start hsqldb.service
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    LOG_INFO "Testing if HSQLDB service is active..."
    systemctl is-active hsqldb.service
    CHECK_RESULT $? 0 0 "HSQLDB service is not active"
    LOG_INFO "Testing HSQLDB command line tool..."
    java -cp /usr/share/java/hsqldb.jar org.hsqldb.cmdline.SqlTool --help > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "HSQLDB command line tool is not working"
    LOG_INFO "Testing HSQLDB JAR file existence..."
    ls -la /usr/share/java/hsqldb.jar
    CHECK_RESULT $? 0 0 "HSQLDB JAR file not found"

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    systemctl stop hsqldb.service
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
