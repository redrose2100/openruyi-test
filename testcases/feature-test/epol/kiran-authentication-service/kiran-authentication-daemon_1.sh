
#!/usr/bin/bash
# 请填写测试用例描述

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "kiran-authentication-service"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 -h 参数
    kiran-authentication-daemon -h
    CHECK_RESULT $? 0 0 "kiran-authentication-daemon -h failed"

    # 测试 --help 参数
    kiran-authentication-daemon --help
    CHECK_RESULT $? 0 0 "kiran-authentication-daemon --help failed"

    # 测试 --help-all 参数
    kiran-authentication-daemon --help-all
    CHECK_RESULT $? 0 0 "kiran-authentication-daemon --help-all failed"

    # 测试 -v 参数
    kiran-authentication-daemon -v
    CHECK_RESULT $? 0 0 "kiran-authentication-daemon -v failed"

    # 测试 --version 参数
    kiran-authentication-daemon --version
    CHECK_RESULT $? 0 0 "kiran-authentication-daemon --version failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "kiran-authentication-service"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
