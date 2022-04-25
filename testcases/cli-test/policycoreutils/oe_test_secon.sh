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
# @Desc      :   Test secon
# #############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function run_test() {
    LOG_INFO "Start to run test."
    #secon -h
    secon -h |grep "Usage"
    CHECK_RESULT $? 0 0 "failed to show message"
    #Show the version
    secon -V |grep "secon"
    CHECK_RESULT $? 0 0 "failed to show the version"
    #Show the role of the context
    secon -r |grep "unconfined_r"
    CHECK_RESULT $? 0 0 "failed to show the role of the context"
    #Show the user of the context
    secon -u |grep "unconfined_u"
    CHECK_RESULT $? 0 0 "failed to show the user of the context"
    #Show the context in "raw" format
    secon -R |grep "user"
    CHECK_RESULT $? 0 0 "failed to show the context in "raw" format"
    #Get the context for the current process
    secon --self |grep "user"
    CHECK_RESULT $? 0 0 "get the context for the current process"
    touch 1
    #Use the context from the specified file
    secon -f 1
    CHECK_RESULT $?
    #Show the sensitivity to clearance range of the context
    secon -m
    CHECK_RESULT $?
    #Show the sensitivity level of the context.
    secon -s|grep "s0"
    CHECK_RESULT $? 0 0 "failed to show the sensitivity level of the context"
    #Show the clearance level of the context
    secon -c |grep "c1023"
    CHECK_RESULT $? 0 0 "failed to show the clearance level of the context"
    #Show the type of the context
    secon -t |grep "unconfined"
    CHECK_RESULT $? 0 0 "failed to show the type of the context"
    #Get the fs context for the current process
    secon --self-fs|grep "user"
    CHECK_RESULT $? 0 0 "failed to get the fs context for the current process"
    #Get the key context for the current process
    secon --self-key|grep "user"
    CHECK_RESULT $? 0 0 "failed to get the key context for the current process"
    #Get the exec context for the current process
    secon --self-exec|grep "user"
    CHECK_RESULT $? 0 0 "failed to get the exec context for the current process"
    LOG_INFO "End to run test."
}

main "$@"
