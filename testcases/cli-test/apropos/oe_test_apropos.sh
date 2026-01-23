#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   gaoshuaishuai
# @Contact   :   gaoshuaishuai@uniontech.com
# @Date      :   2025/07/25
# @License   :   Mulan PSL v2
# @Desc      :   test apropos
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "man-db"
    mandb
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    apropos ls | grep lsinitrd 
    CHECK_RESULT $? 0 0 "Failed to search for the manual page related to 'ls'"
    apropos -r "ls.*" | grep ls
    CHECK_RESULT $? 0 0 "Failed to search for keywords using regular expressions"
    apropos -a tar | grep -E "glGetQueryiv|tar"
    CHECK_RESULT $? 0 0 "Failed to search for entries matching tar"
    apropos -M /usr/share/man ll
    CHECK_RESULT $? 0 0 "Failed to set the search path entry"
    apropos -w "ls*" | grep -q "ls"
    CHECK_RESULT $? 0 0 "Wildcard search failed"
    apropos -C /etc/manpath.config "ls" | grep -q "ls"
    CHECK_RESULT $? 0 0 "Config file not applied"
    apropos -d "ls" 2>&1 | grep -q -E "debug|config file"
    CHECK_RESULT $? 0 0 "Debug mode output failed"
    LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
