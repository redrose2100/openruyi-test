
#!/usr/bin/bash
# 测试kwin_wayland命令的--width参数

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
    kwin_wayland --width 800
    CHECK_RESULT $? 0 0 "kwin_wayland --width 800 failed"

    kwin_wayland --width 1200
    CHECK_RESULT $? 0 0 "kwin_wayland --width 1200 failed"

    kwin_wayland --width 1024 --height 768
    CHECK_RESULT $? 0 0 "kwin_wayland --width 1024 --height 768 failed"

    kwin_wayland --width 1920 --height 1080 --scale 2
    CHECK_RESULT $? 0 0 "kwin_wayland --width 1920 --height 1080 --scale 2 failed"

    kwin_wayland --width 1024 --height 768 --output-count 2
    CHECK_RESULT $? 0 0 "kwin_wayland --width 1024 --height 768 --output-count 2 failed"

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
