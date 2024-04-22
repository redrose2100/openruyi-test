#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   wulei
# @Contact   :   wulei@uniontech.com
# @Date      :   2024-01-09
# @License   :   Mulan PSL v2
# @Desc      :   leveldb basic function
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "gcc-c++ leveldb leveldb-devel"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cat > leveldb_test.cpp << EOF
#include <iostream>
#include <leveldb/db.h>

int main() {
    leveldb::DB* db;
    leveldb::Options options;
    options.create_if_missing = true;

    // 打开数据库
    leveldb::Status status = leveldb::DB::Open(options, "testdb", &db);
    if (!status.ok()) {
        std::cerr << "无法打开数据库: " << status.ToString() << std::endl;
        return 1;
    }

    // 写入数据
    std::string key = "name";
    std::string value = "John";
    status = db->Put(leveldb::WriteOptions(), key, value);
    if (!status.ok()) {
        std::cerr << "写入数据失败: " << status.ToString() << std::endl;
        return 1;
    }

    // 读取数据
    std::string result;
    status = db->Get(leveldb::ReadOptions(), key, &result);
    if (status.ok()) {
        std::cout << "读取数据成功: " << result << std::endl;
    } else {
        std::cerr << "读取数据失败: " << status.ToString() << std::endl;
        return 1;
    }

    // 删除数据
    status = db->Delete(leveldb::WriteOptions(), key);
    if (!status.ok()) {
        std::cerr << "删除数据失败: " << status.ToString() << std::endl;
        return 1;
    }

    // 关闭数据库
    delete db;

    return 0;
}
EOF
    CHECK_RESULT $? 0 0 "File creation failed"
    g++ -o leveldb_test leveldb_test.cpp -lleveldb
    CHECK_RESULT $? 0 0 "Compilation failed"
    test -e leveldb_test
    CHECK_RESULT $? 0 0 "Failed to generate executable file"
    ./leveldb_test | grep '读取数据成功: John'
    CHECK_RESULT $? 0 0 "Execution failed"
    test -e testdb
    CHECK_RESULT $? 0 0 "Failed to generate data file"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf leveldb_test.cpp leveldb_test testdb
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
