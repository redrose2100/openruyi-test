#!/usr/bin/bash
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   wangsongsong 
# @Contact   :   ss_wang@foxmail.com
# @Date      :   2022/02/25
# @License   :   Mulan PSL v2
# @Desc      :   Test semodule
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INTSALL "policycoreutils-python-utils"
    audit2allow -a -M mypolicy
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    #display list of installed modules
    semodule -l |grep bc 
    CHECK_RESULT $? 0 0 "failed to display list of installed modules"
    #reload policy
    semodule -R 
    CHECK_RESULT $? 0 0 "failed to reload policy"
    #build and reload policy
    semodule -B 
    CHECK_RESULT $? 0 0 "failed to build and reload policy"
    #disable zebra module
    semodule -d zebra 
    CHECK_RESULT $? 0 0 "failed to disable zebra module"
    #enable zebra module
    semodule -e zebra 
    CHECK_RESULT $? 0 0 "failed to enable zebra module"
    #install mypolicy module
    semodule -i mypolicy.pp
    CHECK_RESULT $? 0 0 "failed to install mypolicy module"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    LOG_INFO "Nothing to do."

    LOG_INFO "End to restore the test environment."
}

main "$@"
