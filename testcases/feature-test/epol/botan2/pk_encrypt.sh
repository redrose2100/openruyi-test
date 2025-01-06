
#!/usr/bin/bash
# 请填写测试用例描述：测试botan的pk_encrypt命令，加密给定文件

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据
    echo "This is a test file." > ./testfile.txt
    echo "public_key" > ./public_key.pem
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试botan pk_encrypt命令
    botan2 pk_encrypt --aead=AES-256/GCM ./public_key.pem ./testfile.txt
    CHECK_RESULT $? 0 0 "botan2 pk_encrypt command failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "botan2"
    # 清理测试中间产物文件
    rm -f ./testfile.txt ./public_key.pem
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
