
#!/usr/bin/bash
# 本测试用例用于测试xfce4-screensaver-preferences命令的参数功能

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xfce4-screensaver"
    # 准备测试数据等
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助选项
    xfce4-screensaver-preferences --help
    CHECK_RESULT $? 0 0 "failed to show help options"
    
    xfce4-screensaver-preferences --help-all
    CHECK_RESULT $? 0 0 "failed to show all help options"
    
    xfce4-screensaver-preferences --help-gtk
    CHECK_RESULT $? 0 0 "failed to show GTK+ options"
    
    # 测试应用选项
    xfce4-screensaver-preferences -s "12345"
    CHECK_RESULT $? 0 0 "failed to set socket id"
    
    xfce4-screensaver-preferences --display ":0"
    CHECK_RESULT $? 0 0 "failed to set display"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "xfce4-screensaver"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
