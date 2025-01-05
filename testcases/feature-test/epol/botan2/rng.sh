
#!/usr/bin/bash
# 本测试用例用于测试botan2软件包中的rng命令，包括各种参数组合和命令执行结果的验证。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据
    echo "Test data" > ./test_data.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试rng命令的基本用法
    botan2 rng --format=hex 16
    CHECK_RESULT $? 0 0 "Failed to run rng command with --format=hex"
    
    # 测试rng命令的--system参数
    botan2 rng --system 16
    CHECK_RESULT $? 0 0 "Failed to run rng command with --system"
    
    # 测试rng命令的--rdrand参数
    botan2 rng --rdrand 16
    CHECK_RESULT $? 0 0 "Failed to run rng command with --rdrand"
    
    # 测试rng命令的--auto参数
    botan2 rng --auto 16
    CHECK_RESULT $? 0 0 "Failed to run rng command with --auto"
    
    # 测试rng命令的--entropy参数
    botan2 rng --entropy 16
    CHECK_RESULT $? 0 0 "Failed to run rng command with --entropy"
    
    # 测试rng命令的--drbg参数
    botan2 rng --drbg 16
    CHECK_RESULT $? 0 0 "Failed to run rng command with --drbg"
    
    # 测试rng命令的--drbg-seed参数
    botan2 rng --drbg-seed=1234567890 16
    CHECK_RESULT $? 0 0 "Failed to run rng command with --drbg-seed"
    
    # 测试rng命令的组合参数
    botan2 rng --format=hex --system 16
    CHECK_RESULT $? 0 0 "Failed to run rng command with --format=hex and --system"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "botan2"
    # 清理测试中间产物文件
    rm -f ./test_data.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
