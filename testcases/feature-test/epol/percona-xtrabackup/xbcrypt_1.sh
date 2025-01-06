
#!/usr/bin/bash
# 测试 xbcrypt 命令的加密和解密功能

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "percona-xtrabackup"
    # 准备测试数据
    echo "This is a test file." > ./testfile.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试加密功能
    xbcrypt -i ./testfile.txt -o ./encryptedfile.txt -a aes-256-cbc -k "mysecretkey"
    CHECK_RESULT $? 0 0 "Encryption failed"
    # 测试解密功能
    xbcrypt -d -i ./encryptedfile.txt -o ./decryptedfile.txt -a aes-256-cbc -k "mysecretkey"
    CHECK_RESULT $? 0 0 "Decryption failed"
    # 检查解密后的文件内容是否正确
    diff ./testfile.txt ./decryptedfile.txt
    CHECK_RESULT $? 0 0 "Decrypted file content does not match original file"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    DNF_REMOVE "percona-xtrabackup"
    # 清理测试中间产物文件
    rm -f ./testfile.txt ./encryptedfile.txt ./decryptedfile.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
