#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   wangxiaorou
#@Contact       :   wangxiaorou@uniontech.com
#@Date          :   2023-03-28
#@License       :   Mulan PSL v2
#@Desc          :   the function of pcre2grep
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "pcre2 pcre2-devel pcre2-help"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    CHECK_RESULT "$(pcre2-config --version)" "$(rpm -qa pcre2-devel |awk -F "-" '{print $3}')" 0 "get dversion info"  
    CHECK_RESULT "$(echo -e 'name:zhangsan,age:18\nname:lisi,age:20' | pcre2grep -O '$1 $2' 'name:(\w+),age:(\d+)')" "$(echo -e 'zhangsan 18\nlisi 20')" 0 "pcre2grep output text"
    CHECK_RESULT "$(echo -e 'name:zhangsan,age:18\nname:lisi,age:20' | pcre2grep -O '$1' 'name:(\w+),age:(\d+)')" "$(echo -e 'zhangsan\nlisi')" 0 "pcre2grep output text" 
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"

