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
    # test option: -L
    rm -rf /var/run/rrdcached.pid
    rrdcached -L
    CHECK_RESULT $? 0 0 "rrdcached: faild to test option -L"
    # test option: -l
    rm -rf /var/run/rrdcached.pid
    rrdcached -l unix:/root/mugen/testcases/cli-test/rrdtool/common:9999
    CHECK_RESULT $? 0 0 "rrdcached: faild to test option -l"
    # test option: -s
    rm -rf /var/run/rrdcached.pid
    rrdcached -s 1
    CHECK_RESULT $? 0 0 "rrdcached: faild to test option -s"
    # test option: -m
    rm -rf /var/run/rrdcached.pid
    rrdcached -m 777
    CHECK_RESULT $? 0 0 "rrdcached: faild to test option -m"
    # test option: -P
    rm -rf /var/run/rrdcached.pid
    rrdcached -P FLUSH,PENDING $MORE_ARGUMENTS
    CHECK_RESULT $? 0 0 "rrdcached: faild to test option -P"
    # test option: -V
    rm -rf /var/run/rrdcached.pid
    rrdcached -V LOG_ERR
    CHECK_RESULT $? 0 0 "rrdcached: faild to test option -V"
    # test option: -w
    rm -rf /var/run/rrdcached.pid
    rrdcached -w 300
    CHECK_RESULT $? 0 0 "rrdcached: faild to test option -w"
    # test option: -z
    rm -rf /var/run/rrdcached.pid
    rrdcached -z 180
    CHECK_RESULT $? 0 0 "rrdcached: faild to test option -z"
    # test option: -f
    rm -rf /var/run/rrdcached.pid
    rrdcached -f 3600
    CHECK_RESULT $? 0 0 "rrdcached: faild to test option -f"
    # test option: -p
    rm -rf /var/run/rrdcached.pid
    rrdcached -p /var/run/rrdcached.pid
    CHECK_RESULT $? 0 0 "rrdcached: faild to test option -p"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    kill -9 $(pgrep rrdcached)
    rm -rf /var/run/rrdcached.pid /root/mugen/testcases/cli-test/rrdtool/common:9999
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"