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
# @Date      :   2021-09-13
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

    echo "hello world"
    CHECK_RESULT $? 0 0 "Print 'hello world' fail,echo error"

    echo "hello world" > /tmp/test1
    grep "hello world" /tmp/test1
    CHECK_RESULT $? 0 0 "Write in /tmp/test1 fail,echo error"

    echo "nice to meet you" >> /tmp/test1
    grep "nice to meet you" /tmp/test1
    CHECK_RESULT $? 0 0 "Additional text fail,echo error"

}

function post_test(){
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/test1
    LOG_INFO "Finish environment cleanup!"
}

main $@