
#!/usr/bin/bash
# 测试 nmstatectl gc 命令，包括无参数和带参数的情况

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "nmstate"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    echo "example_state: {}" > ./test_state.yaml
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试无参数情况
    nmstatectl gc
    CHECK_RESULT $? 1 0 "nmstatectl gc failed without parameters"

    # 测试带参数情况
    nmstatectl gc ./test_state.yaml
    CHECK_RESULT $? 0 0 "nmstatectl gc failed with parameters"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        DNF_REMOVE "nmstate"
        # 清理测试中间产物文件
    rm -f ./test_state.yaml
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
