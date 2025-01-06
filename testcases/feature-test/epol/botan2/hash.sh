
#!/usr/bin/bash
# 本测试脚本用于测试botan2软件包中的hash命令，包括不同的算法、缓冲区大小、文件名格式等参数组合。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据
    echo "Test data" > ./testfile.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试不同的哈希算法
    botan2 hash --algo=SHA-256 --buf-size=4096 --no-fsname --format=hex ./testfile.txt
    CHECK_RESULT $? 0 0 "SHA-256 hash failed"
    
    # 测试不同的缓冲区大小
    botan2 hash --algo=SHA-256 --buf-size=1024 --no-fsname --format=hex ./testfile.txt
    CHECK_RESULT $? 0 0 "SHA-256 hash with buf-size=1024 failed"
    
    # 测试不同的文件名格式
    botan2 hash --algo=SHA-256 --buf-size=4096 --no-fsname --format=hex ./testfile.txt
    CHECK_RESULT $? 0 0 "SHA-256 hash with no-fsname failed"
    
    # 测试不同的哈希算法和缓冲区大小组合
    botan2 hash --algo=SHA-512 --buf-size=8192 --no-fsname --format=hex ./testfile.txt
    CHECK_RESULT $? 0 0 "SHA-512 hash with buf-size=8192 failed"
    
    # 测试多个文件
    echo "Another test data" > ./another_testfile.txt
    botan2 hash --algo=SHA-256 --buf-size=4096 --no-fsname --format=hex ./testfile.txt ./another_testfile.txt
    CHECK_RESULT $? 0 0 "SHA-256 hash with multiple files failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "botan2"
    # 清理测试中间产物文件
    rm -f ./testfile.txt ./another_testfile.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
