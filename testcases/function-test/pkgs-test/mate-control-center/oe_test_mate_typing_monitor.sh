
#!/usr/bin/bash
# 测试用例描述：测试 mate-typing-monitor 命令的基本功能和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "mate-control-center"
    # 准备测试数据等
    export DISPLAY=:0.0
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试命令的基本功能
    mate-typing-monitor --help
    CHECK_RESULT $? 0 0 "mate-typing-monitor --help failed"

    # 测试 --debug 参数
    mate-typing-monitor --debug
    CHECK_RESULT $? 1 0 "mate-typing-monitor --debug failed"

    # 测试 --no-check 参数
    mate-typing-monitor --no-check
    CHECK_RESULT $? 1 0 "mate-typing-monitor --no-check failed"

    # 测试 --display 参数
    mate-typing-monitor --display=:0.0
    CHECK_RESULT $? 1 0 "mate-typing-monitor --display=:0.0 failed"

    # 测试参数组合
    mate-typing-monitor --debug --no-check --display=:0.0
    CHECK_RESULT $? 1 0 "mate-typing-monitor --debug --no-check --display=:0.0 failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "mate-control-center"
    # 清理测试中间产物文件
    unset DISPLAY
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
