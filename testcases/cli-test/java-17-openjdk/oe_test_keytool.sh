#!/bin/bash
# Copyright (c) 2024 xFusion Digital Technologies Co., Ltd. All rights reserved.
# Decription: 验证serialver命令的基本用法：用于生成Java序列化类的序列版本 UID（serialVersionUID）
# Author:liujuan lw0014554
# Create:2024-10-12

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment!"
    if dnf list | grep "java-17-openjdk"; then
        DNF_INSTALL "java-17-openjdk java-17-openjdk-devel"
    else
        LOG_WARN "The java-17-openjdk package does not exist in the system."
        exit 0
    fi
    cp ../common/MessageContainer.java ./
    LOG_INFO "End to prepare the test environment!"
}

function run_test() {
    LOG_INFO "Start to run test."
    serialver 2>&1 | grep "use:\|serialver"
    CHECK_RESULT $? 0 0 "Failed to check usage."

    javac MessageContainer.java
    test -s MessageContainer.class
    CHECK_RESULT $? 0 0 "Failed to compile java file."

    serialver MessageContainer | grep "MessageContainer:    private static final long serialVersionUID = 1L"
    CHECK_RESULT $? 0 0 "Failed to generate serial version UID of class."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf $(ls | grep -vE ".sh")
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
