
#!/usr/bin/bash
# 测试botan的fingerprint命令，验证其参数和功能

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据
    echo "-----BEGIN PUBLIC KEY-----" > ./test_key.pub
    echo "public key content" >> ./test_key.pub
    echo "-----END PUBLIC KEY-----" >> ./test_key.pub
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试fingerprint命令的基本用法
    botan fingerprint --algo=SHA-256 ./test_key.pub
    CHECK_RESULT $? 0 0 "fingerprint command failed with SHA-256"

    # 测试fingerprint命令的--no-fsname参数
    botan fingerprint --no-fsname --algo=SHA-256 ./test_key.pub
    CHECK_RESULT $? 0 0 "fingerprint command failed with --no-fsname and SHA-256"

    # 测试fingerprint命令的其他哈希算法
    botan fingerprint --algo=SHA-512 ./test_key.pub
    CHECK_RESULT $? 0 0 "fingerprint command failed with SHA-512"

    # 测试fingerprint命令的错误输入
    botan fingerprint --algo=SHA-256 ./nonexistent_key.pub
    CHECK_RESULT $? 1 0 "fingerprint command should fail with nonexistent key"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "botan2"
    # 清理测试中间产物文件
    rm -f ./test_key.pub
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
