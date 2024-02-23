#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   sunqingwei
# @Contact   :   sunqingwei@uniontech.com
# @Date      :   2024/22/23
# @License   :   Mulan PSL v2
# @Desc      :   test sed
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "sed"
  mkdir /home/casetest
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    (echo "test123" ;echo "test456" ) > /home/casetest/sedfile
    grep test123 /home/casetest/sedfile
    CHECK_RESULT $? 0 0 "File write error"
    sed -i s/test123/hello/g /home/casetest/sedfile
    grep test123 /home/casetest/sedfile
    CHECK_RESULT $? 0 1 "File modification failure"
    grep hello /home/casetest/sedfile
    CHECK_RESULT $? 0 0 "File modification failure"
    sed -i '1,2d' /home/casetest/sedfile
    number=$(wc -l < /home/casetest/sedfile)
    CHECK_RESULT "$number" 0 0 "Delete failure"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /home/casetest
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
