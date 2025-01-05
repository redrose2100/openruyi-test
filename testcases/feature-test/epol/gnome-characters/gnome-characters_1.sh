
#!/usr/bin/bash
# 本测试用例用于测试 gnome-characters 命令的各种选项和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "gnome-characters"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 --help 选项
    gnome-characters --help
    CHECK_RESULT $? 0 0 "Failed to show help options with --help"

    # 测试 --help-all 选项
    gnome-characters --help-all
    CHECK_RESULT $? 0 0 "Failed to show all help options with --help-all"

    # 测试 --help-gapplication 选项
    gnome-characters --help-gapplication
    CHECK_RESULT $? 0 0 "Failed to show GApplication options with --help-gapplication"

    # 测试 --help-gtk 选项
    gnome-characters --help-gtk
    CHECK_RESULT $? 0 0 "Failed to show GTK+ options with --help-gtk"

    # 测试 --display 选项
    gnome-characters --display=:0.0
    CHECK_RESULT $? 0 0 "Failed to use --display option"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "gnome-characters"
    # 清理测试中间产物文件
    rm -rf ./testfile*
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
