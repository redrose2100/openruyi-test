
#!/usr/bin/bash
# 本测试脚本用于测试xfdesktop命令的各种参数组合

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
    # 测试显示帮助信息
    xfdesktop --help
    CHECK_RESULT $? 0 0 "xfdesktop --help failed"
    
    # 测试显示所有帮助信息
    xfdesktop --help-all
    CHECK_RESULT $? 0 0 "xfdesktop --help-all failed"
    
    # 测试显示GTK+选项
    xfdesktop --help-gtk
    CHECK_RESULT $? 0 0 "xfdesktop --help-gtk failed"
    
    # 测试显示会话管理选项
    xfdesktop --help-sm-client
    CHECK_RESULT $? 0 0 "xfdesktop --help-sm-client failed"
    
    # 测试显示版本信息
    xfdesktop --version
    CHECK_RESULT $? 0 0 "xfdesktop --version failed"
    
    # 测试重新加载所有设置
    xfdesktop --reload
    CHECK_RESULT $? 0 0 "xfdesktop --reload failed"
    
    # 测试切换到下一个壁纸
    xfdesktop --next
    CHECK_RESULT $? 0 0 "xfdesktop --next failed"
    
    # 测试弹出菜单
    xfdesktop --menu
    CHECK_RESULT $? 0 0 "xfdesktop --menu failed"
    
    # 测试弹出窗口列表
    xfdesktop --windowlist
    CHECK_RESULT $? 0 0 "xfdesktop --windowlist failed"
    
    # 测试自动排列桌面图标
    xfdesktop --arrange
    CHECK_RESULT $? 0 0 "xfdesktop --arrange failed"
    
    # 测试启用调试消息
    xfdesktop --enable-debug
    CHECK_RESULT $? 0 0 "xfdesktop --enable-debug failed"
    
    # 测试禁用调试消息
    xfdesktop --disable-debug
    CHECK_RESULT $? 0 0 "xfdesktop --disable-debug failed"
    
    # 测试不等待窗口管理器启动
    xfdesktop --disable-wm-check
    CHECK_RESULT $? 0 0 "xfdesktop --disable-wm-check failed"
    
    # 测试退出xfdesktop
    xfdesktop --quit
    CHECK_RESULT $? 0 0 "xfdesktop --quit failed"
    
    # 测试指定X display
    xfdesktop --display=:0
    CHECK_RESULT $? 0 0 "xfdesktop --display=:0 failed"
    
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
