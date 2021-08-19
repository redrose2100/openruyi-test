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
#文本打印
    echo "hello world"
    CHECK_RESULT $?
#echo新建文本文件
    echo "hello,this is test:第一句" > /tmp/test1
    cat /tmp/test1 |grep "第一句"
    CHECK_RESULT $?

#echo追加空文本文件
    touch /tmp/test2
    echo "my name is lilei" /tmp/test2
    cat /tmp/test2 |grep "lilei"
    CHECK_RESULT $?
#echo非空文件追加
    echo  "这是第二句" >> /tmp/test1
    cat /tmp/test1 |grep "这是第二句"
    CHECK_RESULT $?
    LOG_INFO "Finish test"
}

function post_test(){
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/test*
    LOG_INFO "Finish environment cleanup!"
}

main $@
