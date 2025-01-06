
#!/usr/bin/bash
# 测试kwin_wayland的--wayland-fd参数

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
    kwin_wayland --wayland-fd 3
    CHECK_RESULT $? 0 0 "kwin_wayland --wayland-fd 3 failed"

    kwin_wayland --wayland-fd 4 --socket wayland-1
    CHECK_RESULT $? 0 0 "kwin_wayland --wayland-fd 4 --socket wayland-1 failed"

    kwin_wayland --wayland-fd 5 --xwayland
    CHECK_RESULT $? 0 0 "kwin_wayland --wayland-fd 5 --xwayland failed"

    kwin_wayland --wayland-fd 6 --lock
    CHECK_RESULT $? 0 0 "kwin_wayland --wayland-fd 6 --lock failed"

    kwin_wayland --wayland-fd 7 --help
    CHECK_RESULT $? 0 0 "kwin_wayland --wayland-fd 7 --help failed"

    kwin_wayland --wayland-fd 8 --version
    CHECK_RESULT $? 0 0 "kwin_wayland --wayland-fd 8 --version failed"

    kwin_wayland --wayland-fd 9 --author
    CHECK_RESULT $? 0 0 "kwin_wayland --wayland-fd 9 --author failed"

    kwin_wayland --wayland-fd 10 --license
    CHECK_RESULT $? 0 0 "kwin_wayland --wayland-fd 10 --license failed"

    kwin_wayland --wayland-fd 11 --desktopfile kwin.desktop
    CHECK_RESULT $? 0 0 "kwin_wayland --wayland-fd 11 --desktopfile kwin.desktop failed"

    kwin_wayland --wayland-fd 12 --xwayland-display :1
    CHECK_RESULT $? 0 0 "kwin_wayland --wayland-fd 12 --xwayland-display :1 failed"

    kwin_wayland --wayland-fd 13 --xwayland-xauthority /tmp/xauth
    CHECK_RESULT $? 0 0 "kwin_wayland --wayland-fd 13 --xwayland-xauthority /tmp/xauth failed"

    kwin_wayland --wayland-fd 14 --replace
    CHECK_RESULT $? 0 0 "kwin_wayland --wayland-fd 14 --replace failed"

    kwin_wayland --wayland-fd 15 --x11-display :0
    CHECK_RESULT $? 0 0 "kwin_wayland --wayland-fd 15 --x11-display :0 failed"

    kwin_wayland --wayland-fd 16 --wayland-display wayland-0
    CHECK_RESULT $? 0 0 "kwin_wayland --wayland-fd 16 --wayland-display wayland-0 failed"

    kwin_wayland --wayland-fd 17 --virtual
    CHECK_RESULT $? 0 0 "kwin_wayland --wayland-fd 17 --virtual failed"

    kwin_wayland --wayland-fd 18 --width 1280 --height 720 --scale 2 --output-count 2
    CHECK_RESULT $? 0 0 "kwin_wayland --wayland-fd 18 --width 1280 --height 720 --scale 2 --output-count 2 failed"

    kwin_wayland --wayland-fd 19 --drm
    CHECK_RESULT $? 0 0 "kwin_wayland --wayland-fd 19 --drm failed"

    kwin_wayland --wayland-fd 20 --inputmethod /path/to/imserver
    CHECK_RESULT $? 0 0 "kwin_wayland --wayland-fd 20 --inputmethod /path/to/imserver failed"

    kwin_wayland --wayland-fd 21 --lockscreen
    CHECK_RESULT $? 0 0 "kwin_wayland --wayland-fd 21 --lockscreen failed"

    kwin_wayland --wayland-fd 22 --no-lockscreen
    CHECK_RESULT $? 0 0 "kwin_wayland --wayland-fd 22 --no-lockscreen failed"

    kwin_wayland --wayland-fd 23 --no-global-shortcuts
    CHECK_RESULT $? 0 0 "kwin_wayland --wayland-fd 23 --no-global-shortcuts failed"

    kwin_wayland --wayland-fd 24 --no-kactivities
    CHECK_RESULT $? 0 0 "kwin_wayland --wayland-fd 24 --no-kactivities failed"

    kwin_wayland --wayland-fd 25 --exit-with-session /path/to/session
    CHECK_RESULT $? 0 0 "kwin_wayland --wayland-fd 25 --exit-with-session /path/to/session failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        # 清理测试中间产物文件
    DNF_REMOVE "kwin"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
