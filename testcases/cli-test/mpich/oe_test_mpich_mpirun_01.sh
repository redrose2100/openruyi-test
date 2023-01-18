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
    LOG_INFO "END to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    mpirun -genv -genvlist -envnone -info -verbose common/ex
    CHECK_RESULT $? 0 0 "Check mpirun -genv -genvlist -envnone -verbose failed"
    mpirun -genv -genvlist -genvnone -envnone -info -verbose common/ex
    CHECK_RESULT $? 0 0 "Check mpirun -genvnone failed"
    mpirun -genv -genvlist -genvnone -genvall -info -envnone -verbose common/ex
    CHECK_RESULT $? 0 0 "Check mpirun -genvall failed"
    mpirun -genv -f -hosts -verbose common/ex | grep 'Proxy launch'
    CHECK_RESULT $? 0 0 "Check mpirun -f -hosts failed"
    mpirun -genv -f -hosts -wdir ./ -verbose common/ex | grep 'Got a control'
    CHECK_RESULT $? 0 0 "Check mpirun -wdir failed"
    mpirun -genv -f -hosts -wdir ./ -configfile /etc/host.conf -verbose common/ex | grep 'GFORTRAN_UNBUFFERED_PRECONNECTED=y'
    CHECK_RESULT $? 0 0 "Check mpirun -configfil failed"
    mpirun -env -envlist -envnone -n 2 -verbose common/ex  | grep '(2 processes)'
    CHECK_RESULT $? 0 0 "Check mpirun -env -envlist -envnone -n -verbose failed"
    mpirun -genv -genvlist -envnone -info common/ex | grep 'HYDRA build details'
    CHECK_RESULT $? 0 0 "Check mpirun -genv -genvlist -envnone -info  failed"
    mpirun -genv -genvlist -envnone -info -print-all-exitcodes -iface -ppn -profile -prepend-rank -prepend-pattern common/ex | grep 'Configure options:'
    CHECK_RESULT $? 0 0 "Check mpirun -print-all-exitcodes -iface -ppn -profile -prepend-rank -prepend-pattern failed"
    mpirun -genv -genvlist -envnone -info -outfile-pattern -errfile-pattern -nameserver -disable-auto-cleanup -disable-hostname-propagation common/ex
    CHECK_RESULT $? 0 0 "Check mpirun -errfile-pattern -nameserver -disable-auto-cleanup -disable-hostname-propagation failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
