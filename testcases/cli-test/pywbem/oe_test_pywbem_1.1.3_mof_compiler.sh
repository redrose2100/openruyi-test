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
#@Date      	:   2022-08-02 10:44:52
#@License   	:   Mulan PSL v2
#@Version   	:   1.0
#@Desc      	:   Test pywbem_mof_compiler command
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    cp -f ./common/CIM_Application26.mof ./
    DNF_INSTALL "docker python3-pywbem"
    sudo docker run -d -it --rm -p 0.0.0.0:15988:5988 -p 0.0.0.0:15989:5989 --name openpegasus kschopmeyer/openpegasus-server:0.1.1
    SLEEP_WAIT 10s
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    mof_compiler -s http://0.0.0.0:15988 --log all='file' CIM_Application26.mof
    test -f mofcompserver.log
    CHECK_RESULT $? 0 0 "mof_compiler: failed to test option --log"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    docker stop openpegasus
    docker rm -f openpegasus
    rm -rf CIM_Application26.mof mofcompserver.log
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}    

main "$@"
