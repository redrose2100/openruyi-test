#!/usr/bin/bash
# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   hukun
#@Contact   	:   hu_kun@hoperun.com
#@Date      	:   2024-3-21
#@License   	:   Mulan PSL v2
#@Desc      	:   Test curl
#####################################
source "$OET_PATH/libs/locallibs/common_lib.sh"

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."
    LOG_INFO "Test curl -o test.html www.baidu.com"
    curl -o test.html www.baidu.com
    CHECK_RESULT $? 0 0 "check curl -o test.html www.baidu.com failed"
    LOG_INFO "Test curl -i -r 0-1024 http://www.sina.com.cn -o sina_part1.html"
    curl -i -r 0-1024 http://www.sina.com.cn -o sina_part1.html
    CHECK_RESULT $? 0 0 "check curl -i -r 0-1024 http://www.sina.com.cn -o sina_part1.html  failed"
    LOG_INFO "Test curl -v www.baidu.com"
    curl -v www.baidu.com
    CHECK_RESULT $? 0 0 "check curl -v www.baidu.com failed"
    LOG_INFO "Test curl -V"
    curl -V
    CHECK_RESULT $? 0 0 "check curl -V failed"
    LOG_INFO "Test curl -y 30 www.baidu.com"
    curl -y 30 www.baidu.com
    CHECK_RESULT $? 0 0 "check curl -y 30 www.baidu.com failed"
    LOG_INFO "Test curl -q www.baidu.com"
    curl -q www.baidu.com
    CHECK_RESULT $? 0 0 "check curl -q www.baidu.com failed"
    LOG_INFO "End to run test."
}

main "$@"
