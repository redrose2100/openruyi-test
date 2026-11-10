#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   Jevons
#@Contact   	:   1557927445@qq.com
#@Date      	:   2021-05-19 09:39:43
#@License   	:   Mulan PSL v2
#@Desc      	:   store password with ciphertext
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    
    useradd test
    
    LOG_INFO "Finish preparing the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    
    echo "huawei666" | passwd --stdin test
    CHECK_RESULT $? 0 0 "set success"
    # 不能硬编码 sha512 的 $6$ 前缀：openRuyi 默认 ENCRYPT_METHOD 为 yescrypt，
    # /etc/shadow 里是 $y$ 开头，硬编码 $6$ 会必然失败。
    # 这里只校验密码字段已写入且不是锁定标记。
    shadow_pwd=$(getent shadow test | awk -F: '{print $2}')
    CHECK_RESULT "$(echo "$shadow_pwd" | grep -cE '^\$[a-zA-Z0-9]+\$')" 1 0 "grep failed"
    echo "$shadow_pwd" | grep -qE '^(!|\*|!!)$' && CHECK_RESULT 1 0 "password is locked"
    
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    
    userdel -rf test
    
    LOG_INFO "End to restore the test environment."
}

main "$@"
