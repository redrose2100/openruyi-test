#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liuyafei1
# @Contact   :   chenyia@uniontech.com
# @Date      :   2023-4-03
# @License   :   Mulan PSL v2
# @Desc      :   Command test-md5sum 
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

<<<<<<< HEAD
=======
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    LOG_INFO "End to prepare the test environment."
}

>>>>>>> fb75928cf517aea2f3a0648eb773646e0e8b93c8
function run_test() {
    LOG_INFO "Start to run test."
    sha256sum --help | grep "Usage: sha256sum"
    CHECK_RESULT $? 0 0 "The file content is abnormal "
    echo "test1234" >testfile
    CHECK_RESULT $? 0 0 "check create file fail"
    sha256sum  testfile  > testfile.sha256sum  
    test -f testfile1.sha256sum
    CHECK_RESULT $? 0 0 "The testfile1.sha256sum is not exit "  
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf testfile testfile.sha256sum
    LOG_INFO "Finish environment cleanup!"
}

main "$@"



