
#!/usr/bin/bash
# 请填写测试用例描述：测试 xfce4-popup-directorymenu 命令的基本功能和参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xfce4-panel"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试无参数调用
    xfce4-popup-directorymenu
    CHECK_RESULT $? 0 0 "xfce4-popup-directorymenu failed without parameters"

    # 测试 --pointer 参数
    xfce4-popup-directorymenu -p
    CHECK_RESULT $? 0 0 "xfce4-popup-directorymenu failed with --pointer parameter"

    # 测试 --help 参数
    xfce4-popup-directorymenu -h
    CHECK_RESULT $? 0 0 "xfce4-popup-directorymenu failed with --help parameter"

    # 测试 --version 参数
    xfce4-popup-directorymenu -V
    CHECK_RESULT $? 0 0 "xfce4-popup-directorymenu failed with --version parameter"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "xfce4-panel"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
