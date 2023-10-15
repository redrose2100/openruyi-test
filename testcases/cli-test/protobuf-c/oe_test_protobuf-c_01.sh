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
# @Date      :   2023/07/20
# @License   :   Mulan PSL v2
# @Desc      :   Test protobuf-c function
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "protobuf-c protobuf-c-devel"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    cat > person.proto <<EOF
syntax = "proto3";
package tencent;

message Person
{
    string name = 1;
    uint32 age  = 2;
    uint64 phnum = 3;
}
EOF
    test -f person.proto
    CHECK_RESULT $? 0 0 "Create person.proto file fail"
    protoc-c --c_out=./ ./person.proto
    CHECK_RESULT $? 0 0 "Compile fail"
    test -f person.pb-c.h
    CHECK_RESULT $? 0 0 "Compile fail"
    test -f person.pb-c.c
    CHECK_RESULT $? 0 0 "Compile fail"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf person.proto person.pb-c.h person.pb-c.c
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

