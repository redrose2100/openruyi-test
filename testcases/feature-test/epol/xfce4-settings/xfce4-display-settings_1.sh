
#!/usr/bin/bash
# 本测试用例用于测试xfce4-display-settings命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xfce4-settings"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助选项
    xfce4-display-settings --help
    CHECK_RESULT $? 0 0 "Failed to show help options"
    
    xfce4-display-settings --help-all
    CHECK_RESULT $? 0 0 "Failed to show all help options"
    
    xfce4-display-settings --help-gtk
    CHECK_RESULT $? 0 0 "Failed to show GTK+ options"
    
    # 测试版本信息
    xfce4-display-settings --version
    CHECK_RESULT $? 0 0 "Failed to show version information"
    
    # 测试最小化界面
    xfce4-display-settings --minimal
    CHECK_RESULT $? 0 0 "Failed to show minimal interface"
    
    # 测试设置X display
    xfce4-display-settings --display=:0.0
    CHECK_RESULT $? 0 0 "Failed to set X display"
    
    # 测试设置socket ID
    xfce4-display-settings --socket-id=12345
    CHECK_RESULT $? 0 0 "Failed to set socket ID"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "xfce4-settings"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
