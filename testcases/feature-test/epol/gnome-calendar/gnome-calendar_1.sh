
#!/usr/bin/bash
# 本测试用例用于测试gnome-calendar命令的基本功能，包括帮助选项、版本信息、日期显示等。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "gnome-calendar"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助选项
    gnome-calendar --help
    CHECK_RESULT $? 0 0 "gnome-calendar --help failed"
    
    # 测试显示所有帮助选项
    gnome-calendar --help-all
    CHECK_RESULT $? 0 0 "gnome-calendar --help-all failed"
    
    # 测试显示GApplication选项
    gnome-calendar --help-gapplication
    CHECK_RESULT $? 0 0 "gnome-calendar --help-gapplication failed"
    
    # 测试显示GTK+选项
    gnome-calendar --help-gtk
    CHECK_RESULT $? 0 0 "gnome-calendar --help-gtk failed"
    
    # 测试显示版本信息
    gnome-calendar --version
    CHECK_RESULT $? 0 0 "gnome-calendar --version failed"
    
    # 测试启用调试消息
    gnome-calendar --debug
    CHECK_RESULT $? 0 0 "gnome-calendar --debug failed"
    
    # 测试打开指定日期的日历
    gnome-calendar --date "2023-10-01"
    CHECK_RESULT $? 0 0 "gnome-calendar --date failed"
    
    # 测试打开指定事件的日历
    gnome-calendar --uuid "some-event-uuid"
    CHECK_RESULT $? 0 0 "gnome-calendar --uuid failed"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "gnome-calendar"
    # 清理测试中间产物文件
    rm -rf ./test_files
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
