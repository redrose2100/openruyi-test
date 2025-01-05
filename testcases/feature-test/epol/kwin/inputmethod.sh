
#!/usr/bin/bash
# 测试 kwin_wayland 的 --inputmethod 参数

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
    kwin_wayland --inputmethod "./path/to/imserver"
    CHECK_RESULT $? 0 0 "kwin_wayland --inputmethod failed"

    kwin_wayland --inputmethod "./path/to/another_imserver"
    CHECK_RESULT $? 0 0 "kwin_wayland --inputmethod with another path failed"

    kwin_wayland --inputmethod "./path/to/imserver" --lock
    CHECK_RESULT $? 0 0 "kwin_wayland --inputmethod with --lock failed"

    kwin_wayland --inputmethod "./path/to/imserver" --lockscreen
    CHECK_RESULT $? 0 0 "kwin_wayland --inputmethod with --lockscreen failed"

    kwin_wayland --inputmethod "./path/to/imserver" --no-lockscreen
    CHECK_RESULT $? 0 0 "kwin_wayland --inputmethod with --no-lockscreen failed"

    kwin_wayland --inputmethod "./path/to/imserver" --no-global-shortcuts
    CHECK_RESULT $? 0 0 "kwin_wayland --inputmethod with --no-global-shortcuts failed"

    kwin_wayland --inputmethod "./path/to/imserver" --no-kactivities
    CHECK_RESULT $? 0 0 "kwin_wayland --inputmethod with --no-kactivities failed"

    kwin_wayland --inputmethod "./path/to/imserver" --exit-with-session "./path/to/session"
    CHECK_RESULT $? 0 0 "kwin_wayland --inputmethod with --exit-with-session failed"

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
