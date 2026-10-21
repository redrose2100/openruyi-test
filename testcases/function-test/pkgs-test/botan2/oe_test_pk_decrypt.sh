
#!/usr/bin/bash
# 请填写测试用例描述：测试botan的pk_decrypt命令，用于使用RSA私钥解密文件

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据
    echo "This is a test message" > ./test_data.txt
    botan2 keygen rsa 2048 ./test_key.pem
    botan2 pk_encrypt ./test_key.pem.pub ./test_data.txt ./test_encrypted_data.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容
    botan2 pk_decrypt ./test_key.pem ./test_encrypted_data.txt ./test_decrypted_data.txt
    CHECK_RESULT $? 0 0 "Failed to decrypt the file using RSA private key"
    cat ./test_decrypted_data.txt | grep "This is a test message"
    CHECK_RESULT $? 0 0 "Decrypted content does not match the original message"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "botan2"
    # 清理测试中间产物文件
    rm -f ./test_data.txt ./test_key.pem ./test_key.pem.pub ./test_encrypted_data.txt ./test_decrypted_data.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
