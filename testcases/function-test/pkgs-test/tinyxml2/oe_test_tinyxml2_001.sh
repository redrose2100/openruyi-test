#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under the Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   yanglang
# @Contact   :   yanglang@uniontech.com
# @Date      :   2026-05-25
# @License   :   Mulan PSL v2
# @Desc      :   tinyxml2 basic function test
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "tinyxml2 tinyxml2-devel gcc gcc-c++"
    LOG_INFO "End of environmental preparation!"
}

function run_test()
{
    LOG_INFO "start to run test."

    cat > test.xml << EOF
<root>
    <name>openEuler</name>
    <version>24.03</version>
</root>
EOF
    CHECK_RESULT $? 0 0 "create test.xml failed"

    cat > test_tinyxml.cpp << EOF
#include <iostream>
#include <tinyxml2.h>
using namespace tinyxml2;

int main() {
    XMLDocument doc;
    doc.LoadFile("test.xml");

    if (doc.Error()) {
        return 1;
    }

    XMLElement *root = doc.FirstChildElement("root");
    const char *name = root->FirstChildElement("name")->GetText();
    const char *ver  = root->FirstChildElement("version")->GetText();

    printf("name: %s\nversion: %s\n", name, ver);
    return 0;
}
EOF
    CHECK_RESULT $? 0 0 "create test_tinyxml.cpp failed"

    g++ test_tinyxml.cpp -o test_tinyxml -ltinyxml2
    CHECK_RESULT $? 0 0 "compile test_tinyxml failed"

    ./test_tinyxml
    CHECK_RESULT $? 0 0 "run test_tinyxml failed"

    LOG_INFO "All test executed successfully!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    #shellcheck disable=SC2119
    DNF_REMOVE
    rm -f test.xml test_tinyxml.cpp test_tinyxml
    LOG_INFO "End to restore the test environment."
}

main "$@"
