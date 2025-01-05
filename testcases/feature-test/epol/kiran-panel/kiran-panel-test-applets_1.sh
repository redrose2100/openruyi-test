
#!/usr/bin/bash
# 本测试用例用于验证kiran-panel-test-applets命令的各个参数是否能够正常工作，包括帮助选项、应用选项以及参数组合。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "kiran-panel"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等

    # 测试 --help 参数
    kiran-panel-test-applets --help
    CHECK_RESULT $? 0 0 "failed to run --help"

    # 测试 --help-all 参数
    kiran-panel-test-applets --help-all
    CHECK_RESULT $? 0 0 "failed to run --help-all"

    # 测试 --help-gtk 参数
    kiran-panel-test-applets --help-gtk
    CHECK_RESULT $? 0 0 "failed to run --help-gtk"

    # 测试 --iid 参数
    kiran-panel-test-applets --iid "org.kde.panel.clock"
    CHECK_RESULT $? 0 0 "failed to run --iid"

    # 测试 --prefs-path 参数
    kiran-panel-test-applets --prefs-path "/org/kde/plasma/panel/"
    CHECK_RESULT $? 0 0 "failed to run --prefs-path"

    # 测试 --size 参数
    kiran-panel-test-applets --size "medium"
    CHECK_RESULT $? 0 0 "failed to run --size"

    # 测试 --orient 参数
    kiran-panel-test-applets --orient "top"
    CHECK_RESULT $? 0 0 "failed to run --orient"

    # 测试 --display 参数
    kiran-panel-test-applets --display ":0"
    CHECK_RESULT $? 0 0 "failed to run --display"

    # 测试多个参数组合
    kiran-panel-test-applets --iid "org.kde.panel.clock" --prefs-path "/org/kde/plasma/panel/" --size "medium" --orient "top" --display ":0"
    CHECK_RESULT $? 0 0 "failed to run multiple parameters"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "kiran-panel"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
