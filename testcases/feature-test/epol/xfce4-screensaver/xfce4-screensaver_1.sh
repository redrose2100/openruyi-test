
#!/usr/bin/bash
# 本测试用例用于测试xfce4-screensaver命令的基本功能，包括显示帮助信息、显示版本信息、启用调试代码以及指定X display。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xfce4-screensaver"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试显示帮助信息
    xfce4-screensaver --help
    CHECK_RESULT $? 0 0 "Failed to show help options"

    # 测试显示所有帮助信息
    xfce4-screensaver --help-all
    CHECK_RESULT $? 0 0 "Failed to show all help options"

    # 测试显示GTK+选项
    xfce4-screensaver --help-gtk
    CHECK_RESULT $? 0 0 "Failed to show GTK+ options"

    # 测试显示版本信息
    xfce4-screensaver --version
    CHECK_RESULT $? 0 0 "Failed to show version information"

    # 测试启用调试代码
    xfce4-screensaver --debug
    CHECK_RESULT $? 0 0 "Failed to enable debugging code"

    # 测试指定X display
    xfce4-screensaver --display=:0.0
    CHECK_RESULT $? 0 0 "Failed to specify X display"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "xfce4-screensaver"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
