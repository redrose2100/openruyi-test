
#!/usr/bin/bash
# 本测试用例用于测试xfce4-keyboard-settings命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xfce4-settings"
    # 准备测试数据等
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助选项
    xfce4-keyboard-settings --help
    CHECK_RESULT $? 0 0 "xfce4-keyboard-settings --help failed"
    
    xfce4-keyboard-settings --help-all
    CHECK_RESULT $? 0 0 "xfce4-keyboard-settings --help-all failed"
    
    xfce4-keyboard-settings --help-gtk
    CHECK_RESULT $? 0 0 "xfce4-keyboard-settings --help-gtk failed"
    
    # 测试版本信息选项
    xfce4-keyboard-settings --version
    CHECK_RESULT $? 0 0 "xfce4-keyboard-settings --version failed"
    
    # 测试socket-id选项
    xfce4-keyboard-settings --socket-id=12345
    CHECK_RESULT $? 0 0 "xfce4-keyboard-settings --socket-id=12345 failed"
    
    # 测试display选项
    xfce4-keyboard-settings --display=:0.0
    CHECK_RESULT $? 0 0 "xfce4-keyboard-settings --display=:0.0 failed"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "xfce4-settings"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
