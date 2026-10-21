
#!/usr/bin/bash
# 请填写测试用例描述：测试kwin_wayland的--lock选项

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
    # 测试--lock参数
    kwin_wayland --lock
    CHECK_RESULT $? 0 0 "kwin_wayland --lock failed"

    # 测试--lock参数与其他参数的组合
    kwin_wayland --lock --width 1280 --height 720
    CHECK_RESULT $? 0 0 "kwin_wayland --lock --width 1280 --height 720 failed"

    kwin_wayland --lock --drm
    CHECK_RESULT $? 0 0 "kwin_wayland --lock --drm failed"

    kwin_wayland --lock --no-lockscreen
    CHECK_RESULT $? 0 0 "kwin_wayland --lock --no-lockscreen failed"

    kwin_wayland --lock --no-global-shortcuts
    CHECK_RESULT $? 0 0 "kwin_wayland --lock --no-global-shortcuts failed"

    kwin_wayland --lock --no-kactivities
    CHECK_RESULT $? 0 0 "kwin_wayland --lock --no-kactivities failed"

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
