#!/usr/bin/bash
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huike
# @Contact   :   754873891@qq.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of mpich command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL mpich
    chmod +777 common/ex
    export PATH="${PATH}:/usr/lib64/mpich/bin"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    mpiexec -genv -genvlist -envnone -info -print-all-exitcodes -iface -ppn -profile -prepend-rank -prepend-pattern -order-nodes common/ex  | grep 'Process Manager'
    CHECK_RESULT $? 0 0 "Check mpiexec -order-nodes failed"
    mpiexec -genv -genvlist -envnone -info -membind -map-by -bind-to -topolib -rmk -disable-x -print-all-exitcodes -localhost -usize common/ex  | grep 'Launchers'
    CHECK_RESULT $? 0 0 "Check mpiexec -membind -map-by -bind-to -topolib -localhost -rmk -usize failed"
    mpiexec -genv -genvlist -envnone -info -ckpointlib -demux -ckpoint-nu -ckpoint-prefix -ckpoint-interval -ckpointlib -print-all-exitcodes -usize common/ex  | grep 'Resource'
    CHECK_RESULT $? 0 0 "Check mpiexec -ckpointlib -demux -ckpoint-nu -ckpoint-prefix -ckpoint-interval -ckpointlib failed"
    mpiexec -genv -genvlist -envnone -info -launcher common/ex | grep 'Demux engines available'
    CHECK_RESULT $? 0 0 "Check mpiexec -launcher failed"
    mpiexec --help 2>&1 | grep 'Usage: ./mpiexec'
    CHECK_RESULT $? 0 0 "Check mpiexec --help failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End restore the test environment."
}

main $@
