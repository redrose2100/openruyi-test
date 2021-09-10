#!/usr/bin/bash

# Copyright (c) 2021 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #######################################################
# @Author    :   chentao
# @Contact   :   chentao@uniontech.com
# @Date      :   2021-08-19
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-echo
# #######################################################
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation"
    ls /tmp/test1 && rm -rf /tmp/test1
    ls /tmp/test2 && rm -rf /tmp/test2
    LOG_INFO "End of enviornment preparation"

}
function do_test() {
    LOG_INFO "Start test"
    LOG_INFO "The text printing"
    echo "hello world"
    CHECK_RESULT $? 0 0 "if can not print "hello world",execute failed"

    LOG_INFO "Create a text file and write text"
    echo "hello,this is first" > /tmp/test1
    grep "first" /tmp/test1
    CHECK_RESULT $? 0 0 "if can not grep 'first',excute failed"

    LOG_INFO "Write the text"
    touch /tmp/test2
    echo "my name is lilei" > /tmp/test2
    grep "lilei" /tmp/test2
    CHECK_RESULT $? 0 0 "if can not grep 'lilei',excute failed"

    LOG_INFO "Append text"
    echo  "this is second" >> /tmp/test1
    grep "second"  /tmp/test1
    CHECK_RESULT $? 0 0 "if can not grep 'second',excute failed"
    LOG_INFO "Finish test"
}

function post_test(){
    LOG_INFO "Start environment cleanup."
    rm -rf /tmp/test*
    LOG_INFO "Finish environment cleanup!"
}

main $@
