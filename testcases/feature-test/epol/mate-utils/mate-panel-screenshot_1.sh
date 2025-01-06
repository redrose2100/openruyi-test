
#!/usr/bin/bash
# 本测试脚本用于测试mate-panel-screenshot命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "mate-utils"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试命令的基本用法
    mate-panel-screenshot
    CHECK_RESULT $? 0 0 "mate-panel-screenshot failed to take a screenshot of the entire screen"

    # 测试 -w 参数
    mate-panel-screenshot -w
    CHECK_RESULT $? 0 0 "mate-panel-screenshot failed to take a screenshot of a window"

    # 测试 -a 参数
    mate-panel-screenshot -a
    CHECK_RESULT $? 0 0 "mate-panel-screenshot failed to take a screenshot of an area"

    # 测试 -c 参数
    mate-panel-screenshot -c
    CHECK_RESULT $? 0 0 "mate-panel-screenshot failed to send the screenshot to the clipboard"

    # 测试 -b 参数
    mate-panel-screenshot -b
    CHECK_RESULT $? 0 0 "mate-panel-screenshot failed to include the window border"

    # 测试 -B 参数
    mate-panel-screenshot -B
    CHECK_RESULT $? 0 0 "mate-panel-screenshot failed to remove the window border"

    # 测试 -d 参数
    mate-panel-screenshot -d 5
    CHECK_RESULT $? 0 0 "mate-panel-screenshot failed to take a screenshot after a delay"

    # 测试 -e 参数
    mate-panel-screenshot -e shadow
    CHECK_RESULT $? 0 0 "mate-panel-screenshot failed to add a shadow effect to the border"

    # 测试 --version 参数
    mate-panel-screenshot --version
    CHECK_RESULT $? 0 0 "mate-panel-screenshot failed to print version information"

    # 测试 --display 参数
    mate-panel-screenshot --display=:0
    CHECK_RESULT $? 0 0 "mate-panel-screenshot failed to use the specified X display"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "mate-utils"
    # 清理测试中间产物文件
    rm -f ./screenshot*.png
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
