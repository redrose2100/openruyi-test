
#!/usr/bin/bash
# 测试botan hmac命令，包括不同的哈希算法和文件输入

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据
    echo "test data" > ./testfile1
    echo "more test data" > ./testfile2
    # 创建一个密钥文件
    echo "secretkey" > ./keyfile
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试不同的哈希算法
    botan hmac --hash=SHA-256 --buf-size=4096 --no-fsname ./keyfile ./testfile1
    CHECK_RESULT $? 0 0 "failed to run hmac with SHA-256"
    botan hmac --hash=SHA-512 --buf-size=4096 --no-fsname ./keyfile ./testfile1
    CHECK_RESULT $? 0 0 "failed to run hmac with SHA-512"
    
    # 测试多个文件输入
    botan hmac --hash=SHA-256 --buf-size=4096 --no-fsname ./keyfile ./testfile1 ./testfile2
    CHECK_RESULT $? 0 0 "failed to run hmac with multiple files"
    
    # 测试不同的缓冲区大小
    botan hmac --hash=SHA-256 --buf-size=1024 --no-fsname ./keyfile ./testfile1
    CHECK_RESULT $? 0 0 "failed to run hmac with buf-size 1024"
    botan hmac --hash=SHA-256 --buf-size=8192 --no-fsname ./keyfile ./testfile1
    CHECK_RESULT $? 0 0 "failed to run hmac with buf-size 8192"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "botan2"
    # 清理测试中间产物文件
    rm -f ./testfile1 ./testfile2 ./keyfile
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
