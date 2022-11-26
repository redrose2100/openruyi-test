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
#@Author    	:   @meitingli
#@Contact   	:   bubble_mt@outlook.com
#@Date      	:   2021-05-08
#@License   	:   Mulan PSL v2
#@Desc      	:   aio read file 
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    [[ ! -f ./aio_read_file ]] && {
        make
    }
    echo "append read only file" > test_aio_read_file
    filebytes=$(ls -l test_aio_read_file | awk '{print $5}')
    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    readbytes=$(echo test_aio_read_file | ./aio_read_file)
    [[ $readbytes -eq $filebytes ]] 
    CHECK_RESULT $? 0 0 "Aio read file failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f test_aio_read_file
    make clean
    LOG_INFO "End to restore the test environment."
}

main "$@"

