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
#@Author    	:   LifanHan
#@Contact   	:   514362169@qq.com
#@Date      	:   2022-08-01 17:35:05
#@License   	:   Mulan PSL v2
#@Version   	:   1.0
#@Desc      	:   Test pywbem_mof_compiler command
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "docker python3-pywbem"
    cp -f ./common/CIM_Application26.mof ./
    sudo docker pull hub.firefly.store/kschopmeyer/openpegasus-server:0.1.1
    sudo docker run -d -it --rm -p 0.0.0.0:15988:5988 -p 0.0.0.0:15989:5989 --name openpegasus hub.firefly.store/kschopmeyer/openpegasus-server:0.1.1
    SLEEP_WAIT 10s
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    if [ "${NODE1_FRAME}" == x86_64 ]; then
        mof_compiler -s http://0.0.0.0:15988 CIM_Application26.mof
        CHECK_RESULT $? 0 0 "mof_compiler: failed to test option -s"
        mof_compiler -s http://0.0.0.0:15988 -n root/cimv2 CIM_Application26.mof
        CHECK_RESULT $? 0 0 "mof_compiler: failed to test option -n"
        mof_compiler -s http://0.0.0.0:15988 -u test_user -p test_p CIM_Application26.mof
        CHECK_RESULT $? 0 0 "mof_compiler: failed to test option -u"
        mof_compiler -s http://0.0.0.0:15988 -p test_p CIM_Application26.mof
        CHECK_RESULT $? 0 0 "mof_compiler: failed to test option -p"
        mof_compiler -s http://0.0.0.0:15988 -nvc CIM_Application26.mof
        CHECK_RESULT $? 0 0 "mof_compiler: failed to test option -nvc"
        mof_compiler -s http://0.0.0.0:15988 --cacerts ./ CIM_Application26.mof
        CHECK_RESULT $? 0 0 "mof_compiler: failed to test option --cacerts"
        mof_compiler -s http://0.0.0.0:15988 --certfile ./ CIM_Application26.mof
        CHECK_RESULT $? 0 0 "mof_compiler: failed to test option --certfile"
        mof_compiler -s http://0.0.0.0:15988 --keyfile ./ CIM_Application26.mof
        CHECK_RESULT $? 0 0 "mof_compiler: failed to test option --keyfile"
        mof_compiler -s http://0.0.0.0:15988 -r CIM_Application26.mof
        CHECK_RESULT $? 0 0 "mof_compiler: failed to test option -r"
        mof_compiler -s http://0.0.0.0:15988 -d CIM_Application26.mof | grep "Executing in dry-run mode"
        CHECK_RESULT $? 0 0 "mof_compiler: failed to test option -d"
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    docker stop openpegasus
    docker rm -f openpegasus
    DNF_REMOVE "$@"
    rm -rf CIM_Application26.mof
    LOG_INFO "End to restore the test environment."
}

main "$@"
