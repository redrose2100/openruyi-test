
#!/usr/bin/bash
# 请填写测试用例描述：测试botan factor命令，用于因式分解给定的整数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    echo "1234567890" > ./test_number.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    botan factor 1234567890
    CHECK_RESULT $? 0 0 "botan factor command failed"
    botan factor 9876543210
    CHECK_RESULT $? 0 0 "botan factor command failed"
    botan factor 12345678901234567890
    CHECK_RESULT $? 0 0 "botan factor command failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        # 清理测试中间产物文件
    DNF_REMOVE "botan2"
    rm -f ./test_number.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
