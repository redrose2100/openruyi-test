
#!/usr/bin/bash
# 本测试用例用于测试xfwm4-tweaks-settings命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xfwm4"
    # 准备测试数据等
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助选项
    xfwm4-tweaks-settings --help
    CHECK_RESULT $? 0 0 "Failed to show help options"
    
    # 测试显示所有帮助选项
    xfwm4-tweaks-settings --help-all
    CHECK_RESULT $? 0 0 "Failed to show all help options"
    
    # 测试显示GTK+选项
    xfwm4-tweaks-settings --help-gtk
    CHECK_RESULT $? 0 0 "Failed to show GTK+ options"
    
    # 测试显示版本信息
    xfwm4-tweaks-settings --version
    CHECK_RESULT $? 0 0 "Failed to show version information"
    
    # 测试指定会话管理器套接字
    xfwm4-tweaks-settings --socket-id=12345
    CHECK_RESULT $? 0 0 "Failed to set session manager socket"
    
    # 测试指定X display
    xfwm4-tweaks-settings --display=:0.0
    CHECK_RESULT $? 0 0 "Failed to set X display"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "xfwm4"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
