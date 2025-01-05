
#!/usr/bin/bash
# 本测试用例用于测试xfce4-mouse-settings命令的各种参数组合

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
    xfce4-mouse-settings --help
    CHECK_RESULT $? 0 0 "xfce4-mouse-settings --help failed"
    
    xfce4-mouse-settings --help-all
    CHECK_RESULT $? 0 0 "xfce4-mouse-settings --help-all failed"
    
    xfce4-mouse-settings --help-gtk
    CHECK_RESULT $? 0 0 "xfce4-mouse-settings --help-gtk failed"
    
    # 测试版本信息
    xfce4-mouse-settings --version
    CHECK_RESULT $? 0 0 "xfce4-mouse-settings --version failed"
    
    # 测试设备选项
    xfce4-mouse-settings --device="Mouse"
    CHECK_RESULT $? 0 0 "xfce4-mouse-settings --device=Mouse failed"
    
    # 测试套接字选项
    xfce4-mouse-settings --socket-id=12345
    CHECK_RESULT $? 0 0 "xfce4-mouse-settings --socket-id=12345 failed"
    
    # 测试显示选项
    xfce4-mouse-settings --display=:0
    CHECK_RESULT $? 0 0 "xfce4-mouse-settings --display=:0 failed"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "xfce4-settings"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
