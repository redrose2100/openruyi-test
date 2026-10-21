
#!/usr/bin/bash
# 测试botan tls_ciphers命令，验证其在不同参数组合下的行为

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试默认参数
    botan tls_ciphers --policy=default --version=tls1.2
    CHECK_RESULT $? 0 0 "tls_ciphers with default parameters failed"

    # 测试不同的TLS版本
    botan tls_ciphers --policy=default --version=tls1.3
    CHECK_RESULT $? 1 0 "tls_ciphers with TLS 1.3 should fail"

    # 测试不同的策略
    botan tls_ciphers --policy=secure --version=tls1.2
    CHECK_RESULT $? 1 0 "tls_ciphers with secure policy should fail"

    # 测试错误的TLS版本
    botan tls_ciphers --policy=default --version=tls1.0
    CHECK_RESULT $? 1 0 "tls_ciphers with TLS 1.0 should fail"

    # 测试错误的策略
    botan tls_ciphers --policy=invalid --version=tls1.2
    CHECK_RESULT $? 1 0 "tls_ciphers with invalid policy should fail"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "botan2"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
