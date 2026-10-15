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
# @Desc      :   Test jsoncpp serialize and deserialize function
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
    // JSON serialization
    Json::Value root;
    root["id"] = 10086;
    root["username"] = "test_user";
    root["is_active"] = true;
    root["score"] = 98.5;

    Json::StyledWriter writer;
    std::string json_str = writer.write(root);

    // JSON deserialization
    Json::Reader reader;
    Json::Value parse_root;
    reader.parse(json_str, parse_root);

    // Output result
    std::cout << "ID: " << parse_root["id"].asInt() << std::endl;
    std::cout << "Username: " << parse_root["username"].asString() << std::endl;
    std::cout << "IsActive: " << parse_root["is_active"].asBool() << std::endl;
    std::cout << "Score: " << parse_root["score"].asDouble() << std::endl;

    return 0;
}
EOF
    CHECK_RESULT $? 0 0 "Create jsoncpp_test.cpp file fail"
    g++ -o jsoncpp_test jsoncpp_test.cpp -ljsoncpp
    CHECK_RESULT $? 0 0 "Compile jsoncpp_test fail"
    ./jsoncpp_test | grep -E "ID: 10086|Username: test_user|IsActive: 1|Score: 98.5"
    CHECK_RESULT $? 0 0 "Execution jsoncpp_test fail"
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

