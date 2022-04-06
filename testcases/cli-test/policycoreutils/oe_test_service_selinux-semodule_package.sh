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
# @Desc      :   Test semodule_package
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

# 测试对象、测试需要的工具等安装准备
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    audit2allow -a -M httpd 
    checkmodule -M -m -o httpd.mod httpd.te
    LOG_INFO "End to prepare the test environment."
}

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."
    #Create a SELinux policy module package
    semodule_package -o httpd.pp -m  httpd.mod -f /etc/selinux/targeted/contexts/files/file_contexts
    CHECK_RESULT $? 0 0 "failed to create a SELinux policy module package"
    LOG_INFO "End to run test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."
    test -f httpd.pp && rm -rf httpd.pp
    test -f httpd.mod && rm -rf httpd.mod
    test -f httpd.te && rm -rf httpd.te
    LOG_INFO "End to restore the test environment."
}

main "$@"
