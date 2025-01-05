
#!/usr/bin/bash
# 测试 fec_encode 命令的基本功能和参数组合

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
    # 测试 fec_encode 命令的基本功能
    botan2 fec_encode --suffix=fec --prefix= --output-dir=./ 3 5 ./test_data.txt
    CHECK_RESULT $? 0 0 "fec_encode command failed"

    # 测试 fec_encode 命令的参数组合
    botan2 fec_encode --suffix=share --prefix=prefix_ --output-dir=./ 2 4 ./test_data.txt
    CHECK_RESULT $? 0 0 "fec_encode command with parameters failed"

    # 测试 fec_encode 命令的错误输入
    botan2 fec_encode --suffix=fec --prefix= --output-dir=./ 0 5 ./test_data.txt
    CHECK_RESULT $? 1 0 "fec_encode command with invalid k value should fail"

    # 测试 fec_encode 命令的错误输入
    botan2 fec_encode --suffix=fec --prefix= --output-dir=./ 3 0 ./test_data.txt
    CHECK_RESULT $? 1 0 "fec_encode command with invalid n value should fail"

    # 测试 fec_encode 命令的错误输入
    botan2 fec_encode --suffix=fec --prefix= --output-dir=./ 3 5 ./nonexistent_file.txt
    CHECK_RESULT $? 1 0 "fec_encode command with nonexistent file should fail"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "botan2"
    # 清理测试中间产物文件
    rm -f ./test_data.txt
    rm -f ./prefix_*.share
    rm -f ./test_data.txt.fec*
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
