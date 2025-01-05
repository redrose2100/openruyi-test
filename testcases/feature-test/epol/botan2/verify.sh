
#!/usr/bin/bash
# 测试botan verify命令，验证给定文件的签名

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据
    echo "Test data" > ./test_data.txt
    echo "Signature data" > ./signature_data.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试botan verify命令的基本用法
    botan verify --hash=SHA-256 --emsa= ./test_data.txt ./signature_data.txt
    CHECK_RESULT $? 0 0 "botan verify command failed"

    # 测试--der-format参数
    botan verify --der-format --hash=SHA-256 --emsa= ./test_data.txt ./signature_data.txt
    CHECK_RESULT $? 0 0 "botan verify command with --der-format failed"

    # 测试不同的哈希算法
    botan verify --hash=SHA-512 --emsa= ./test_data.txt ./signature_data.txt
    CHECK_RESULT $? 0 0 "botan verify command with --hash=SHA-512 failed"

    # 测试不同的EMSA参数
    botan verify --hash=SHA-256 --emsa=EMSA1 ./test_data.txt ./signature_data.txt
    CHECK_RESULT $? 0 0 "botan verify command with --emsa=EMSA1 failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "botan2"
    # 清理测试中间产物文件
    rm -f ./test_data.txt ./signature_data.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
