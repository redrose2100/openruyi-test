
#!/usr/bin/bash
# 测试botan sign命令，验证其参数组合和功能

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据
    echo "This is a test message" > ./test_message.txt
    echo "This is a test key" > ./test_key.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试sign命令的基本用法
    botan2 sign --hash=SHA-256 ./test_key.txt ./test_message.txt
    CHECK_RESULT $? 0 0 "botan2 sign command failed"

    # 测试--der-format参数
    botan2 sign --der-format --hash=SHA-256 ./test_key.txt ./test_message.txt
    CHECK_RESULT $? 0 0 "botan2 sign --der-format command failed"

    # 测试--passphrase参数
    botan2 sign --passphrase=testpass --hash=SHA-256 ./test_key.txt ./test_message.txt
    CHECK_RESULT $? 0 0 "botan2 sign --passphrase command failed"

    # 测试--emsa参数
    botan2 sign --emsa=EMSA1 --hash=SHA-256 ./test_key.txt ./test_message.txt
    CHECK_RESULT $? 0 0 "botan2 sign --emsa command failed"

    # 测试--provider参数
    botan2 sign --provider=openssl --hash=SHA-256 ./test_key.txt ./test_message.txt
    CHECK_RESULT $? 0 0 "botan2 sign --provider command failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "botan2"
    # 清理测试中间产物文件
    rm -f ./test_message.txt ./test_key.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
