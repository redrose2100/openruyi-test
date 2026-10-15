#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   caowenqian
# @Contact   :   caowenqian@uniontech.com
# @Date      :   2023/11/02
# @License   :   Mulan PSL v2
# @Desc      :   Test yasm function
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "jsoncpp jsoncpp-devel gcc-c++"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    cat >jsoncpp_test.cpp<<EOF
#include <json/json.h>
#include <iostream>

int main() {
    Json::Value root;

    root["name"] = "John";
    root["age"] = 30;
    root["city"] = "New York";

    std::string name = root["name"].asString();
    int age = root["age"].asInt();
    std::string city = root["city"].asString();

    std::cout << "Name: " << name << std::endl;
    std::cout << "Age: " << age << std::endl;
    std::cout << "City: " << city << std::endl;

    return 0;
}
EOF
    test -f jsoncpp_test.cpp
    CHECK_RESULT $? 0 0 "Create jsoncpp_test.cpp file fail"
    g++ -o jsoncpp_test jsoncpp_test.cpp -ljsoncpp
    test -f jsoncpp_test
    CHECK_RESULT $? 0 0 "Execution fail"
    ./jsoncpp_test | grep "Name: John                        
Age: 30
City: New York"
    CHECK_RESULT $? 0 0 "Execution fail"
    LOG_INFO "Finish test!"
}
function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf jsoncpp_test jsoncpp_test.cpp
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
