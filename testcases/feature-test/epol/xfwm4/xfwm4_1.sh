
#!/usr/bin/bash
# 本测试脚本用于测试xfwm4命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xfwm4"
    # 创建一个X display环境
    export DISPLAY=:0
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 --help 参数
    xfwm4 --help
    CHECK_RESULT $? 0 0 "xfwm4 --help failed"

    # 测试 --help-all 参数
    xfwm4 --help-all
    CHECK_RESULT $? 0 0 "xfwm4 --help-all failed"

    # 测试 --help-gtk 参数
    xfwm4 --help-gtk
    CHECK_RESULT $? 0 0 "xfwm4 --help-gtk failed"

    # 测试 --help-sm-client 参数
    xfwm4 --help-sm-client
    CHECK_RESULT $? 0 0 "xfwm4 --help-sm-client failed"

    # 测试 --version 参数
    xfwm4 --version
    CHECK_RESULT $? 0 0 "xfwm4 --version failed"

    # 测试 --compositor 参数
    xfwm4 --compositor=on
    CHECK_RESULT $? 0 0 "xfwm4 --compositor=on failed"
    xfwm4 --compositor=off
    CHECK_RESULT $? 0 0 "xfwm4 --compositor=off failed"

    # 测试 --vblank 参数
    xfwm4 --vblank=off
    CHECK_RESULT $? 0 0 "xfwm4 --vblank=off failed"
    xfwm4 --vblank=glx
    CHECK_RESULT $? 0 0 "xfwm4 --vblank=glx failed"

    # 测试 --replace 参数
    xfwm4 --replace
    CHECK_RESULT $? 0 0 "xfwm4 --replace failed"

    # 测试 --display 参数
    xfwm4 --display=:0
    CHECK_RESULT $? 0 0 "xfwm4 --display=:0 failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "xfwm4"
    # 清理测试中间产物文件
    unset DISPLAY
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
