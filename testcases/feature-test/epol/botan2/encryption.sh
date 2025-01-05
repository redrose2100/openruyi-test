
#!/usr/bin/bash
# 测试botan encryption命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据
    echo "This is a test file." > ./testfile.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试encryption命令的基本用法
    botan encryption --key=12345678901234567890123456789012 --mode=aes-256-ctr --buf-size=4096 --iv=12345678901234567890123456789012 --ad=12345678901234567890123456789012 --output=./encrypted.txt ./testfile.txt
    CHECK_RESULT $? 0 0 "encryption command failed"
    
    # 测试encryption命令的解密功能
    botan encryption --key=12345678901234567890123456789012 --mode=aes-256-ctr --buf-size=4096 --iv=12345678901234567890123456789012 --ad=12345678901234567890123456789012 --decrypt --output=./decrypted.txt ./encrypted.txt
    CHECK_RESULT $? 0 0 "decryption command failed"
    
    # 测试encryption命令的错误用法
    botan encryption --key=12345678901234567890123456789012 --mode=aes-256-ctr --buf-size=4096 --iv=12345678901234567890123456789012 --ad=12345678901234567890123456789012 --output=./encrypted.txt ./nonexistentfile.txt
    CHECK_RESULT $? 1 0 "encryption command with nonexistent file should fail"
    
    # 测试encryption命令的其他参数组合
    botan encryption --key=12345678901234567890123456789012 --mode=aes-256-cbc --buf-size=4096 --iv=12345678901234567890123456789012 --ad=12345678901234567890123456789012 --output=./encrypted.txt ./testfile.txt
    CHECK_RESULT $? 0 0 "encryption command with aes-256-cbc mode failed"
    
    botan encryption --key=12345678901234567890123456789012 --mode=aes-256-cbc --buf-size=4096 --iv=12345678901234567890123456789012 --ad=12345678901234567890123456789012 --decrypt --output=./decrypted.txt ./encrypted.txt
    CHECK_RESULT $? 0 0 "decryption command with aes-256-cbc mode failed"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "botan2"
    # 清理测试中间产物文件
    rm -f ./testfile.txt ./encrypted.txt ./decrypted.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
