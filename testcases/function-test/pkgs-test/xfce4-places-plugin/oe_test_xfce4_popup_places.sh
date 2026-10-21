
#!/usr/bin/bash
# 请填写测试用例描述：测试 xfce4-popup-places 命令的基本功能和参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xfce4-places-plugin"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试命令的基本功能
    xfce4-popup-places
    CHECK_RESULT $? 0 0 "xfce4-popup-places command failed to run"

    # 测试 -p 参数
    xfce4-popup-places -p
    CHECK_RESULT $? 0 0 "xfce4-popup-places -p command failed to run"

    # 测试 --pointer 参数
    xfce4-popup-places --pointer
    CHECK_RESULT $? 0 0 "xfce4-popup-places --pointer command failed to run"

    # 测试 -h 参数
    xfce4-popup-places -h | grep "Usage:"
    CHECK_RESULT $? 0 0 "xfce4-popup-places -h command failed to show help"

    # 测试 --help 参数
    xfce4-popup-places --help | grep "Usage:"
    CHECK_RESULT $? 0 0 "xfce4-popup-places --help command failed to show help"

    # 测试 -V 参数
    xfce4-popup-places -V | grep "Version"
    CHECK_RESULT $? 0 0 "xfce4-popup-places -V command failed to show version"

    # 测试 --version 参数
    xfce4-popup-places --version | grep "Version"
    CHECK_RESULT $? 0 0 "xfce4-popup-places --version command failed to show version"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "xfce4-places-plugin"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
