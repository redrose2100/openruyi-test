#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   xiongneng
# @Contact   :   xiongneng@uniontech.com
# @Date      :   2024/01/12
# @License   :   Mulan PSL v2
# @Desc      :   Basic functional verification of glog
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "glog glog-devel gcc-c++"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cat > glog_test.cpp << EOF
#include <glog/logging.h>
int main(int argc, char** argv) {
google::InitGoogleLogging(argv[0]);
LOG(INFO) << "This is an informational message";
LOG(WARNING) << "This is a warning message";
LOG(ERROR) << "This is an error message";
google::ShutdownGoogleLogging();
return 0;
}
EOF
    test -f glog_test.cpp
    CHECK_RESULT $? 0 0 "File generation failed"
    g++ -o glog_test glog_test.cpp -lglog
    test -f glog_test
    CHECK_RESULT $? 0 0 "File generation failed"
    ./glog_test
    CHECK_RESULT $? 0 0 "Log message acquisition failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf glog_test.cpp glog_test
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
