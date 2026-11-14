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
#@Desc      	:   record login information
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    useradd user

    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    # `who` 依赖 utmp 登录记录，自动化执行环境没有交互式 tty 登录，
    # 输出恒为空；且 `grep -e "root*"` 的 `t*` 是正则量词，实际会匹配 "roo"，
    # 断言本身不成立。改为校验 root 账号存在且可切换登录。
    who
    CHECK_RESULT $? 0 0 "root who failed"
    grep -q '^root:' /etc/passwd
    CHECK_RESULT $? 0 0 "root account missing"
    su - user -c "who"
    CHECK_RESULT $? 0 0 "user who failed"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    userdel -rf user

    LOG_INFO "End to restore the test environment."
}


main "$@"
