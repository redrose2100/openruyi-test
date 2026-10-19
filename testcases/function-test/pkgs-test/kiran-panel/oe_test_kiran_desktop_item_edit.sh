
#!/usr/bin/bash
# 本测试用例用于测试 kiran-desktop-item-edit 命令的基本功能，包括帮助选项和应用选项。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "kiran-panel"
    # 准备测试数据
    touch "./test.desktop"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助选项
    kiran-desktop-item-edit --help
    CHECK_RESULT $? 0 0 "Failed to show help options"
    
    kiran-desktop-item-edit --help-all
    CHECK_RESULT $? 0 0 "Failed to show all help options"
    
    kiran-desktop-item-edit --help-gtk
    CHECK_RESULT $? 0 0 "Failed to show GTK+ options"
    
    # 测试应用选项
    kiran-desktop-item-edit --create-new "./"
    CHECK_RESULT $? 0 0 "Failed to create new file"
    
    kiran-desktop-item-edit --display=:0 "./test.desktop"
    CHECK_RESULT $? 0 0 "Failed to use display option"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "kiran-panel"
    # 清理测试中间产物文件
    rm -f "./test.desktop"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
