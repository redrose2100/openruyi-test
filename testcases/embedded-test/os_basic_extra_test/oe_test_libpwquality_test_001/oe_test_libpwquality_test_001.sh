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
#@Author    	:   wangshan
#@Contact   	:   wang_shan001@hoperun.com
#@Date      	:   2024-01-23 14:39:43
#@License   	:   Mulan PSL v2
#@Desc      	:   Run libpwquality testsuite
#####################################
# shellcheck disable=SC1091
source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start to run libpwquality test."
    pwmake 20 2>&1 | grep "outside of the allowed entropy range"
    CHECK_RESULT $? 0 0 "check pwmake failed!"
    pwmake 128 | grep '[a-z|A-Z|0-9]'
    CHECK_RESULT $? 0 0 "check pwmake failed!"
    echo "password" | pwscore 2>&1 | grep "contains less than 3 character"
    CHECK_RESULT $? 0 0 "check pwscore failed!"
    echo 'ME@fgty6723' | pwscore | grep "71"
    CHECK_RESULT $? 0 0 "check pwscore failed!"
    LOG_INFO "End to run libpwquality test."
}

main "$@"
