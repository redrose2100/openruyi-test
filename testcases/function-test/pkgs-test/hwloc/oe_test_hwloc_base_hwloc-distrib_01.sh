#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   zhangshaowei
#@Contact       :   756800989@qq.com
#@Date          :   2022-08-15
#@License       :   Mulan PSL v2
#@Desc          :   Test hwloc-distrib
#####################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "hwloc"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    hwloc-distrib --ignore core:0 2 | grep "0x0000000"
    CHECK_RESULT $? 0 0 "hwloc-distrib --ignore failed"
    hwloc-distrib --from core:0 2 | grep "0x0000000"
    CHECK_RESULT $? 0 0 "hwloc-distrib --from failed"
    hwloc-distrib --to core:0 2 | grep "0x0000000"
    CHECK_RESULT $? 0 0 "hwloc-distrib --to failed"
    hwloc-distrib --at core:0 2 | grep "0x0000000"
    CHECK_RESULT $? 0 0 "hwloc-distrib --at failed"
    hwloc-distrib --reverse 2  | grep "0x0000000"
    CHECK_RESULT $? 0 0 "hwloc-distrib --reverse failed"
    hwloc-distrib --restrict core:0 2 | grep "0x0000000"
    CHECK_RESULT $? 0 0 "hwloc-distrib --restrict failed"
    hwloc-distrib --whole-system 2 | grep "0x0000000"
    CHECK_RESULT $? 0 0 "hwloc-distrib --whole-system failed"
    lstopo tep.xml
    hwloc-distrib --input tep.xml 2 | grep "0x0000000"
    CHECK_RESULT $? 0 0 "hwloc-distrib --input <xml> failed"
    hwloc-distrib --input / 2 | grep "0x0000000"
    CHECK_RESULT $? 0 0 "hwloc-distrib --input <directory> failed "
    hwloc-distrib --version | grep "hwloc-distrib"
    CHECK_RESULT $? 0 0 "hwloc-distrib --version failed"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -f tep.xml
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}
main "$@"

