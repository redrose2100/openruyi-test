
#!/usr/bin/bash
# 测试用例描述：测试 ckeygen 命令的基本功能和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "python-twisted"
    # 准备测试数据
    echo "test_private_key" > ./test_key
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 ckeygen 命令的基本功能
    ckeygen -f ./test_key -t rsa -b 2048
    CHECK_RESULT $? 0 0 "ckeygen command failed to create key"
    
    # 测试 ckeygen 命令的参数组合
    ckeygen -f ./test_key -t rsa -b 2048 -C "Test Comment" -N "newpass" -P "oldpass"
    CHECK_RESULT $? 0 0 "ckeygen command failed with combined options"
    
    # 测试 ckeygen 命令的其他参数
    ckeygen -f ./test_key -t rsa -b 2048 -l
    CHECK_RESULT $? 0 0 "ckeygen command failed to show fingerprint"
    
    ckeygen -f ./test_key -t rsa -b 2048 -p
    CHECK_RESULT $? 0 0 "ckeygen command failed to change passphrase"
    
    ckeygen -f ./test_key -t rsa -b 2048 -y
    CHECK_RESULT $? 0 0 "ckeygen command failed to show public key"
    
    ckeygen -f ./test_key -t rsa -b 2048 --no-passphrase
    CHECK_RESULT $? 0 0 "ckeygen command failed to create key with no passphrase"
    
    ckeygen -f ./test_key -t rsa -b 2048 --private-key-subtype PEM
    CHECK_RESULT $? 0 0 "ckeygen command failed to specify private key subtype"
    
    ckeygen -f ./test_key -t rsa -b 2048 --quiet
    CHECK_RESULT $? 0 0 "ckeygen command failed with quiet option"
    
    ckeygen --version
    CHECK_RESULT $? 0 0 "ckeygen command failed to display version"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "python-twisted"
    # 清理测试中间产物文件
    rm -f ./test_key
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
