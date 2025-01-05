
#!/usr/bin/bash
# 测试用例描述：测试 mate-default-applications-properties 命令的基本功能和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "mate-control-center"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试命令的基本用法
    mate-default-applications-properties --display=:0
    CHECK_RESULT $? 0 0 "mate-default-applications-properties command failed to run"

    # 测试 --help 选项
    mate-default-applications-properties --help
    CHECK_RESULT $? 0 0 "mate-default-applications-properties --help failed"

    # 测试 --help-all 选项
    mate-default-applications-properties --help-all
    CHECK_RESULT $? 0 0 "mate-default-applications-properties --help-all failed"

    # 测试 --help-gtk 选项
    mate-default-applications-properties --help-gtk
    CHECK_RESULT $? 0 0 "mate-default-applications-properties --help-gtk failed"

    # 测试 --show-page 参数
    mate-default-applications-properties --display=:0 --show-page=internet
    CHECK_RESULT $? 0 0 "mate-default-applications-properties --show-page=internet failed"

    mate-default-applications-properties --display=:0 --show-page=multimedia
    CHECK_RESULT $? 0 0 "mate-default-applications-properties --show-page=multimedia failed"

    mate-default-applications-properties --display=:0 --show-page=system
    CHECK_RESULT $? 0 0 "mate-default-applications-properties --show-page=system failed"

    mate-default-applications-properties --display=:0 --show-page=a11y
    CHECK_RESULT $? 0 0 "mate-default-applications-properties --show-page=a11y failed"

    # 测试 --display 参数
    mate-default-applications-properties --display=:0
    CHECK_RESULT $? 0 0 "mate-default-applications-properties --display=:0 failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "mate-control-center"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
