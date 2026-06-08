#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   yangxi
# @Contact   :   yangxi@uniontech.com
# @Date      :   2026/06/01
# @License   :   Mulan PSL v2
# @Desc      :   Test jsoncpp array operation function
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "jsoncpp jsoncpp-devel gcc-c++"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    cat > jsoncpp_test.cpp << EOF
#include <json/json.h>
#include <iostream>
#include <string>

int main() {
    // Create JSON array
    Json::Value arr(Json::arrayValue);
    arr.append("C++");
    arr.append("Python");
    arr.append("Java");
    arr.append("Go");

    // Traverse array
    for (int i = 0; i < arr.size(); ++i) {
        std::cout << "Language " << i << ": " << arr[i].asString() << std::endl;
    }

    return 0;
}
EOF

    CHECK_RESULT $? 0 0 "Create jsoncpp_test.cpp failed"
    g++ -o jsoncpp_test jsoncpp_test.cpp -ljsoncpp
    CHECK_RESULT $? 0 0 "Compile jsoncpp_test failed"

    ./jsoncpp_test | grep "Language 0: C++"
    CHECK_RESULT $? 0 0 "Run jsoncpp_test failed"

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    rm -rf jsoncpp_test jsoncpp_test.cpp
    # shellcheck disable=SC2119
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
