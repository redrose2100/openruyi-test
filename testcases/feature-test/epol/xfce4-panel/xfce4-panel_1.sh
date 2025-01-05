
#!/usr/bin/bash
# 本测试用例用于测试xfce4-panel命令的基本功能，包括显示帮助信息、显示版本信息、添加新插件、保存面板配置、重启和退出面板实例等。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xfce4-panel"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试显示帮助信息
    xfce4-panel --help
    CHECK_RESULT $? 0 0 "Failed to show help options"

    # 测试显示所有帮助信息
    xfce4-panel --help-all
    CHECK_RESULT $? 0 0 "Failed to show all help options"

    # 测试显示GTK+选项
    xfce4-panel --help-gtk
    CHECK_RESULT $? 0 0 "Failed to show GTK+ options"

    # 测试显示会话管理选项
    xfce4-panel --help-sm-client
    CHECK_RESULT $? 0 0 "Failed to show session management options"

    # 测试显示版本信息
    xfce4-panel --version
    CHECK_RESULT $? 0 0 "Failed to show version information"

    # 测试添加新插件
    xfce4-panel --add=plugin-name
    CHECK_RESULT $? 0 0 "Failed to add new plugin"

    # 测试保存面板配置
    xfce4-panel --save
    CHECK_RESULT $? 0 0 "Failed to save panel configuration"

    # 测试重启面板实例
    xfce4-panel --restart
    CHECK_RESULT $? 0 0 "Failed to restart panel instance"

    # 测试退出面板实例
    xfce4-panel --quit
    CHECK_RESULT $? 0 0 "Failed to quit panel instance"

    # 测试不等待窗口管理器启动
    xfce4-panel --disable-wm-check
    CHECK_RESULT $? 0 0 "Failed to disable window manager check"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "xfce4-panel"
    # 清理测试中间产物文件
    rm -rf ./plugin-name
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
