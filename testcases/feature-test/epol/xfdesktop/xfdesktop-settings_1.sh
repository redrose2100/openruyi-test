
#!/usr/bin/bash
# 本测试脚本用于测试xfdesktop-settings命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xfdesktop"
    # 准备测试数据等
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助选项
    xfdesktop-settings --help
    CHECK_RESULT $? 0 0 "Failed to show help options"
    
    xfdesktop-settings --help-all
    CHECK_RESULT $? 0 0 "Failed to show all help options"
    
    xfdesktop-settings --help-gtk
    CHECK_RESULT $? 0 0 "Failed to show GTK+ options"
    
    # 测试版本信息
    xfdesktop-settings --version
    CHECK_RESULT $? 0 0 "Failed to show version information"
    
    # 测试调试信息
    xfdesktop-settings --enable-debug
    CHECK_RESULT $? 0 0 "Failed to enable debug messages"
    
    # 测试socket-id参数
    xfdesktop-settings --socket-id=12345
    CHECK_RESULT $? 0 0 "Failed to set socket-id"
    
    # 测试display参数
    xfdesktop-settings --display=:0.0
    CHECK_RESULT $? 0 0 "Failed to set display"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "xfdesktop"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
