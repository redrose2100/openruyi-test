
#!/usr/bin/bash
# 本测试用例用于测试mate-keyboard-properties命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "mate-control-center"
    # 准备测试数据等
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助选项
    mate-keyboard-properties --help
    CHECK_RESULT $? 0 0 "Failed to show help options"
    
    mate-keyboard-properties --help-all
    CHECK_RESULT $? 0 0 "Failed to show all help options"
    
    mate-keyboard-properties --help-gtk
    CHECK_RESULT $? 0 0 "Failed to show GTK+ options"
    
    # 测试应用选项
    mate-keyboard-properties --apply
    CHECK_RESULT $? 0 0 "Failed to apply settings and quit"
    
    mate-keyboard-properties --init-session-settings
    CHECK_RESULT $? 0 0 "Failed to apply session settings and quit"
    
    mate-keyboard-properties --typing-break
    CHECK_RESULT $? 0 0 "Failed to start with typing break settings"
    
    mate-keyboard-properties --a11y
    CHECK_RESULT $? 0 0 "Failed to start with accessibility settings"
    
    # 测试X display选项
    mate-keyboard-properties --display=:0
    CHECK_RESULT $? 0 0 "Failed to use specified X display"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "mate-control-center"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
