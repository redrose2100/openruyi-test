
#!/usr/bin/bash
# 本测试用例用于测试xfce4-settings-manager命令的基本功能，包括帮助选项、版本信息和显示特定设置对话框。

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
    xfce4-settings-manager --help
    CHECK_RESULT $? 0 0 "Failed to show help options"
    
    # 测试所有帮助选项
    xfce4-settings-manager --help-all
    CHECK_RESULT $? 0 0 "Failed to show all help options"
    
    # 测试GTK+选项
    xfce4-settings-manager --help-gtk
    CHECK_RESULT $? 0 0 "Failed to show GTK+ options"
    
    # 测试版本信息
    xfce4-settings-manager --version
    CHECK_RESULT $? 0 0 "Failed to show version information"
    
    # 测试显示特定设置对话框
    xfce4-settings-manager --dialog=appearance
    CHECK_RESULT $? 0 0 "Failed to show appearance settings dialog"
    
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
