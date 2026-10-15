#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-dNFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -O.

# #############################################
# @Author    :   chenzirui
# @Contact   :   ziruichen@126.com
# @Date      :   2022/10/01
# @License   :   Mulan PSL v2
# @Desc      :   Test rrdtool
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "rrdtool"
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    # test option: -t
    rm -rf /var/run/rrdcached.pid
    rrdcached -t 4
    CHECK_RESULT $? 0 0 "rrdcached: faild to test option -t"
    # test option: -j
    rm -rf /var/run/rrdcached.pid
    mkdir journal
    rrdcached -j journal
    CHECK_RESULT $? 0 0 "rrdcached: faild to test option -j"
    # test option: -F
    rm -rf /var/run/rrdcached.pid
    rrdcached -F
    CHECK_RESULT $? 0 0 "rrdcached: faild to test option -F"
    # test option: -b
    rm -rf /var/run/rrdcached.pid
    rrdcached -b /tmp
    CHECK_RESULT $? 0 0 "rrdcached: faild to test option -b"
    # test option: -B
    rm -rf /var/run/rrdcached.pid
    rrdcached -b /tmp -B
    CHECK_RESULT $? 0 0 "rrdcached: faild to test option -B"
    # test option: -R
    rm -rf /var/run/rrdcached.pid
    rrdcached -b /tmp -B -R
    CHECK_RESULT $? 0 0 "rrdcached: faild to test option -R"
    # test option: -a
    rm -rf /var/run/rrdcached.pid
    rrdcached -a 1
    CHECK_RESULT $? 0 0 "rrdcached: faild to test option -a"
    # test option: -O
    rm -rf /var/run/rrdcached.pid
    rrdcached -O
    CHECK_RESULT $? 0 0 "rrdcached: faild to test option -O"
    # test option: -G
    rm -rf /var/run/rrdcached.pid
    rrdcached -G 1
    CHECK_RESULT $? 0 0 "rrdcached: faild to test option -G"
    # test option: -U
    rm -rf /var/run/rrdcached.pid
    rrdcached -U 1
    CHECK_RESULT $? 0 0 "rrdcached: faild to test option -U"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    kill -9 $(pgrep rrdcached)
    rm -rf journal /var/run/rrdcached.pid
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"