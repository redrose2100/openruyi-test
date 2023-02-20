#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

##############################################
#@Author    :   zhangshaowei
#@Contact   :   756800989@qq.com
#@Date      :   2022/07/26
#@License   :   Mulan PSL v2
#@Desc      :   Test hwloc-annotate,hwloc-calc_02
##############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "hwloc"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    hwloc-calc --disallowed --largest Machine:0 | grep "Machine:0"
    CHECK_RESULT $? 0 0 "hwloc-calc --disallowed failed"
    hwloc-calc --restrict-flags 0  Machine:0 | grep "0x0000"
    CHECK_RESULT $? 0 0 "hwloc-calc --restrict-flags <n> failed"
    hwloc-calc --help | grep "Usage: hwloc-calc"
    CHECK_RESULT $? 0 0 "hwloc-calc --help failed"
    hwloc-calc --nodeset Machine:0 | grep "0x"
    CHECK_RESULT $? 0 0 "hwloc-calc --nodeset failed"
    hwloc-calc --nodeset-output -I pu Machine:0 | grep '0'
    CHECK_RESULT $? 0 0 "hwloc-calc --nodeset-output failed"
    hwloc-calc --nodeset-input -I pu Machine:0 | grep "0"
    CHECK_RESULT $? 0 0 "hwloc-calc --nodeset-input failed"
    hwloc-annotate --cu ./common/input.xml output.xml Core:all none && stat output.xml | grep "output.xml" 
    CHECK_RESULT $? 0 0 "hwloc-annotate --cu failed"
    hwloc-annotate -h | grep "Usage: hwloc-annotate"
    CHECK_RESULT $? 0 0 "hwloc-annotate -h failed "
    hwloc-annotate --help | grep "Usage: hwloc-annotate"
    CHECK_RESULT $? 0 0 "hwloc-annotate --help failed"
    hwloc-annotate --version | grep "hwloc-annotate"
    CHECK_RESULT $? 0 0 "hwloc-annotate --version failed"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf output.xml
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
