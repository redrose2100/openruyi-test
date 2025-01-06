
#!/usr/bin/bash
# 本测试用例用于测试gnome-photos的基本命令行参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "gnome-photos"
    # 确保命令路径正确
    export PATH=$PATH:/usr/bin
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 --help 参数
    gnome-photos --help
    CHECK_RESULT $? 0 0 "Failed to run --help option"

    # 测试 --help-all 参数
    gnome-photos --help-all
    CHECK_RESULT $? 0 0 "Failed to run --help-all option"

    # 测试 --help-gapplication 参数
    gnome-photos --help-gapplication
    CHECK_RESULT $? 0 0 "Failed to run --help-gapplication option"

    # 测试 --help-gtk 参数
    gnome-photos --help-gtk
    CHECK_RESULT $? 0 0 "Failed to run --help-gtk option"

    # 测试 --empty-results 参数
    gnome-photos --empty-results
    CHECK_RESULT $? 0 0 "Failed to run --empty-results option"

    # 测试 --version 参数
    gnome-photos --version
    CHECK_RESULT $? 0 0 "Failed to run --version option"

    # 测试 --display 参数
    gnome-photos --display=:0
    CHECK_RESULT $? 0 0 "Failed to run --display option"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "gnome-photos"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
