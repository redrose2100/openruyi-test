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
    hwloc-distrib --input "node:2 2" 2 | grep "0x"
    CHECK_RESULT $? 0 0 "hwloc-distrib --input 'node:2 2' failed"
    hwloc-distrib -i "node:2 2" 2 | grep "0x"
    CHECK_RESULT $? 0 0 "hwloc-distrib -i 'node:2 2' failed"
    hwloc-distrib --input-format xml 2 | grep "0x0000000"
    CHECK_RESULT $? 0 0 "hwloc-distrib --input-format failed"
    hwloc-distrib --if xml 2 | grep "0x0000000"
    CHECK_RESULT $? 0 0 "hwloc-distrib --if failed"
    hwloc-distrib --single 2 | grep "0x0000000"
    CHECK_RESULT $? 0 0 "hwloc-distrib --single failed"
    hwloc-distrib --taskset 2 | grep "0x"
    CHECK_RESULT $? 0 0 "hwloc-distrib --taskset failed"
    hwloc-distrib -v 2 | grep "0x000000"
    CHECK_RESULT $? 0 0 "hwloc-distrib -v failed"
    hwloc-distrib --verbose  2 | grep "0x000000"
    CHECK_RESULT $? 0 0 "hwloc-distrib --verbose failed"
    lstopo tep.xml
    hwloc-distrib -i tep.xml 2 | grep "0x0000000"
    CHECK_RESULT $? 0 0 "hwloc-distrib -i <xml> failed"
    hwloc-distrib -i / 2 | grep "0x0000000"
    CHECK_RESULT $? 0 0 "hwloc-distrib -i <directory> failed "
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf tep.xml
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"

