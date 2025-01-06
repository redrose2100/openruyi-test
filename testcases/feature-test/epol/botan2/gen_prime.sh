
#!/usr/bin/bash
# 请填写测试用例描述：测试botan gen_prime命令，生成指定数量和位数的素数

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
    # 测试生成一个1024位的素数
    botan gen_prime --count=1 1024
    CHECK_RESULT $? 0 0 "Failed to generate a 1024-bit prime number"

    # 测试生成两个512位的素数
    botan gen_prime --count=2 512
    CHECK_RESULT $? 0 0 "Failed to generate two 512-bit prime numbers"

    # 测试生成三个256位的素数
    botan gen_prime --count=3 256
    CHECK_RESULT $? 0 0 "Failed to generate three 256-bit prime numbers"

    # 测试生成一个0位的素数，预期失败
    botan gen_prime --count=1 0
    CHECK_RESULT $? 1 0 "Unexpectedly succeeded to generate a 0-bit prime number"

    # 测试生成一个负数位的素数，预期失败
    botan gen_prime --count=1 -1024
    CHECK_RESULT $? 1 0 "Unexpectedly succeeded to generate a -1024-bit prime number"

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
