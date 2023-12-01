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
#@Author    	:   czjoyit@qq.com
#@Contact   	:   czjoyit@qq.com
#@Date      	:   2022/07/26
#@License   	:   Mulan PSL v2
#@Version   	:   1.0
#@Desc      	:   Take the test rhash command
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test()
{
    #In the openEuler 22.03 LTS system, the version of the rhash is rhash-1.4.2
    #In the openEuler 20.03 LTS SP3 system, the version of the rhash is rhash-1.4.0
    LOG_INFO "Start to prepare the test environment."
    cp -f ./common/test1K.data .
    mkdir tmp_dir&&cp -f test1K.data tmp_dir/
    DNF_INSTALL "rhash"
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    rhash --tiger test1K.data 2>&1 | grep "d25963c1686c96fb8881f6d10c439a7fe853c906e4eb3662  test1K.data"
    CHECK_RESULT $? 0 0 "error --tiger"
    rhash --snefru128 test1K.data 2>&1 | grep "7479ed8c193a23af522f1b8c1a853758  test1K.data"
    CHECK_RESULT $? 0 0 "error --snefru128"
    rhash --snefru256 test1K.data 2>&1 | grep "4c2f2a13ac7745d117838b0be8ebb39bedd5d44b332ae8c973ac07efb50abac0  test1K.data"
    CHECK_RESULT $? 0 0 "error --snefru256"
    rhash --all test1K.data 2>&1 | grep "test1K.data"
    CHECK_RESULT $? 0 0 "error --all"
    rhash --magnet -a test1K.data>tmp_dir/t.magnet
    rhash --check -v tmp_dir/t.magnet 2>&1 |grep "test1K.data *OK"
    CHECK_RESULT $? 0 0 "error --check"
    rhash --ignore-case --update tmp_dir/tmp_update tmp_dir/t.magnet 2>&1 | grep "tmp_update"
    CHECK_RESULT $? 0 0 "error --update or error --ignore-case "
    rhash --crc32 test1K.data | rhash -vc --embed-crc - | grep "Everything OK"    
    CHECK_RESULT $? 0 0 "error --embed-crc"
    rhash --embed-crc tmp_dir/test1K.data
    rhash --check-embedded tmp_dir/'test1K [B70B4C26].data'
    CHECK_RESULT $? 0 0 "error --check-embedded"
    rhash --list-hashes 2>&1 | grep -E '^CRC32'
    CHECK_RESULT $? 0 0 "error --list-hashes"
    rhash --benchmark 2>&1 | grep "benchmarking..." 
    CHECK_RESULT $? 0 0 "error --benchmark"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf test1K.data tmp_dir
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
