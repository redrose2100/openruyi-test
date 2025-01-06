
#!/usr/bin/bash
# 本测试用例用于测试mate-system-monitor命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "mate-system-monitor"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助选项
    mate-system-monitor --help
    CHECK_RESULT $? 0 0 "Failed to show help options"

    # 测试各个应用选项
    mate-system-monitor -s
    CHECK_RESULT $? 0 0 "Failed to show System tab"

    mate-system-monitor -p
    CHECK_RESULT $? 0 0 "Failed to show Processes tab"

    mate-system-monitor -r
    CHECK_RESULT $? 0 0 "Failed to show Resources tab"

    mate-system-monitor -f
    CHECK_RESULT $? 0 0 "Failed to show File Systems tab"

    # 测试多个选项组合
    mate-system-monitor -s -p
    CHECK_RESULT $? 0 0 "Failed to show System and Processes tabs"

    mate-system-monitor -r -f
    CHECK_RESULT $? 0 0 "Failed to show Resources and File Systems tabs"

    mate-system-monitor -s -p -r -f
    CHECK_RESULT $? 0 0 "Failed to show all tabs"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "mate-system-monitor"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
