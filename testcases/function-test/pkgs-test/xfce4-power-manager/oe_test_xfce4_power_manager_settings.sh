
#!/usr/bin/bash
# 本测试用例用于测试xfce4-power-manager-settings命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xfce4-power-manager"
    # 准备测试数据等
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助选项
    xfce4-power-manager-settings -h
    CHECK_RESULT $? 0 0 "failed to show help options"
    xfce4-power-manager-settings --help
    CHECK_RESULT $? 0 0 "failed to show help options"
    xfce4-power-manager-settings --help-all
    CHECK_RESULT $? 0 0 "failed to show all help options"
    xfce4-power-manager-settings --help-gapplication
    CHECK_RESULT $? 0 0 "failed to show GApplication options"
    xfce4-power-manager-settings --help-gtk
    CHECK_RESULT $? 0 0 "failed to show GTK+ Options"

    # 测试应用选项
    xfce4-power-manager-settings --version
    CHECK_RESULT $? 0 0 "failed to display version information"
    xfce4-power-manager-settings --quit
    CHECK_RESULT $? 0 0 "failed to quit xfce4-power-manager-settings"

    # 测试其他参数组合
    xfce4-power-manager-settings --display=:0.0
    CHECK_RESULT $? 0 0 "failed to use X display"
    xfce4-power-manager-settings --socket-id=12345
    CHECK_RESULT $? 0 0 "failed to use socket id"
    xfce4-power-manager-settings --device-id=/org/freedesktop/UPower/devices/DisplayDevice
    CHECK_RESULT $? 0 0 "failed to display specific device"
    xfce4-power-manager-settings --debug
    CHECK_RESULT $? 0 0 "failed to enable debugging"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "xfce4-power-manager"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
