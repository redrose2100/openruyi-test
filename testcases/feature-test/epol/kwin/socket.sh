
#!/usr/bin/bash
# 请填写测试用例描述：测试kwin_wayland的--socket参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "kwin"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    kwin_wayland --socket "wayland-test" -h
    CHECK_RESULT $? 0 0 "kwin_wayland --socket test failed"

    kwin_wayland --socket "wayland-test" --version
    CHECK_RESULT $? 0 0 "kwin_wayland --socket --version test failed"

    kwin_wayland --socket "wayland-test" --lock
    CHECK_RESULT $? 0 0 "kwin_wayland --socket --lock test failed"

    kwin_wayland --socket "wayland-test" --crashes 1
    CHECK_RESULT $? 0 0 "kwin_wayland --socket --crashes test failed"

    kwin_wayland --socket "wayland-test" --xwayland
    CHECK_RESULT $? 0 0 "kwin_wayland --socket --xwayland test failed"

    kwin_wayland --socket "wayland-test" --wayland-fd 3
    CHECK_RESULT $? 0 0 "kwin_wayland --socket --wayland-fd test failed"

    kwin_wayland --socket "wayland-test" --xwayland-fd 4
    CHECK_RESULT $? 0 0 "kwin_wayland --socket --xwayland-fd test failed"

    kwin_wayland --socket "wayland-test" --xwayland-display ":1"
    CHECK_RESULT $? 0 0 "kwin_wayland --socket --xwayland-display test failed"

    kwin_wayland --socket "wayland-test" --xwayland-xauthority "/tmp/xauth"
    CHECK_RESULT $? 0 0 "kwin_wayland --socket --xwayland-xauthority test failed"

    kwin_wayland --socket "wayland-test" --replace
    CHECK_RESULT $? 0 0 "kwin_wayland --socket --replace test failed"

    kwin_wayland --socket "wayland-test" --x11-display ":0"
    CHECK_RESULT $? 0 0 "kwin_wayland --socket --x11-display test failed"

    kwin_wayland --socket "wayland-test" --wayland-display "wayland-0"
    CHECK_RESULT $? 0 0 "kwin_wayland --socket --wayland-display test failed"

    kwin_wayland --socket "wayland-test" --virtual
    CHECK_RESULT $? 0 0 "kwin_wayland --socket --virtual test failed"

    kwin_wayland --socket "wayland-test" --width 1280
    CHECK_RESULT $? 0 0 "kwin_wayland --socket --width test failed"

    kwin_wayland --socket "wayland-test" --height 720
    CHECK_RESULT $? 0 0 "kwin_wayland --socket --height test failed"

    kwin_wayland --socket "wayland-test" --scale 2
    CHECK_RESULT $? 0 0 "kwin_wayland --socket --scale test failed"

    kwin_wayland --socket "wayland-test" --output-count 2
    CHECK_RESULT $? 0 0 "kwin_wayland --socket --output-count test failed"

    kwin_wayland --socket "wayland-test" --drm
    CHECK_RESULT $? 0 0 "kwin_wayland --socket --drm test failed"

    kwin_wayland --socket "wayland-test" --inputmethod "/path/to/imserver"
    CHECK_RESULT $? 0 0 "kwin_wayland --socket --inputmethod test failed"

    kwin_wayland --socket "wayland-test" --lockscreen
    CHECK_RESULT $? 0 0 "kwin_wayland --socket --lockscreen test failed"

    kwin_wayland --socket "wayland-test" --no-lockscreen
    CHECK_RESULT $? 0 0 "kwin_wayland --socket --no-lockscreen test failed"

    kwin_wayland --socket "wayland-test" --no-global-shortcuts
    CHECK_RESULT $? 0 0 "kwin_wayland --socket --no-global-shortcuts test failed"

    kwin_wayland --socket "wayland-test" --no-kactivities
    CHECK_RESULT $? 0 0 "kwin_wayland --socket --no-kactivities test failed"

    kwin_wayland --socket "wayland-test" --exit-with-session "/path/to/session"
    CHECK_RESULT $? 0 0 "kwin_wayland --socket --exit-with-session test failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        DNF_REMOVE "kwin"
        # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
