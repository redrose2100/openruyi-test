#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   pengrui
# @Contact   :   pengrui@uniontech.com
# @Date      :   2023.2.13
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-nspr
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    cat > /tmp/test_nspr1.cpp  <<EOF
#include "nspr.h"
#include <string>
#include <iostream>
using namespace std;
int main()
{
string strTest = "this is a test.";
PR_SetLogFile("/root/nspr_log.log");
PR_LogPrint("%s", strTest.c_str());
PR_LogPrint("%d", 100);
PR_LogPrint("2021年11月08日 UOS 10:40:35");
return 0;
}
EOF
    DNF_INASTALL "nspr-devel"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    rpm -qa | grep nspr
    CHECK_RESULT $? 0 0 "Return value error"
    cd /tmp && g++ test_nspr1.cpp -o test_nspr1 -I /usr/include/nspr4 -L /usr/lib64 -lnspr4
    test -f /tmp/test_nspr1
    CHECK_RESULT $? 0 0 "compile testfile fail"    
    ./test_nspr1
    test -f /root/nspr_log.log
    CHECK_RESULT $? 0 0 "Generate log fail "
    grep "this is a test" /root/nspr_log.log |
    CHECK_RESULT $? 0 0 "information is error"   
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/test_nspr1 test_nspr1.cpp /root/nspr_log.log
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main $@
