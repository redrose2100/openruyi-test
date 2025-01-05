
#!/usr/bin/bash
# 测试xfce4-accessibility-settings命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xfce4-settings"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 -h 参数
    xfce4-accessibility-settings -h
    CHECK_RESULT $? 0 0 "xfce4-accessibility-settings -h failed"

    # 测试 --help 参数
    xfce4-accessibility-settings --help
    CHECK_RESULT $? 0 0 "xfce4-accessibility-settings --help failed"

    # 测试 --help-all 参数
    xfce4-accessibility-settings --help-all
    CHECK_RESULT $? 0 0 "xfce4-accessibility-settings --help-all failed"

    # 测试 --help-gtk 参数
    xfce4-accessibility-settings --help-gtk
    CHECK_RESULT $? 0 0 "xfce4-accessibility-settings --help-gtk failed"

    # 测试 --version 参数
    xfce4-accessibility-settings -v
    CHECK_RESULT $? 0 0 "xfce4-accessibility-settings -v failed"

    # 测试 --socket-id 参数
    xfce4-accessibility-settings --socket-id=12345
    CHECK_RESULT $? 0 0 "xfce4-accessibility-settings --socket-id=12345 failed"

    # 测试 --display 参数
    xfce4-accessibility-settings --display=:0.0
    CHECK_RESULT $? 0 0 "xfce4-accessibility-settings --display=:0.0 failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "xfce4-settings"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
