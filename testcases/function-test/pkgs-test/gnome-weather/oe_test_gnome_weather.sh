
#!/usr/bin/bash
# 请填写测试用例描述：测试 gnome-weather 命令的基本功能和参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "gnome-weather"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助选项
    gnome-weather --help
    CHECK_RESULT $? 0 0 "Failed to show help options"
    
    gnome-weather --help-all
    CHECK_RESULT $? 0 0 "Failed to show all help options"
    
    gnome-weather --help-gapplication
    CHECK_RESULT $? 0 0 "Failed to show GApplication options"
    
    gnome-weather --help-gtk
    CHECK_RESULT $? 0 0 "Failed to show GTK+ options"
    
    # 测试应用选项
    gnome-weather --display=:0.0
    CHECK_RESULT $? 0 0 "Failed to use --display option"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "gnome-weather"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
