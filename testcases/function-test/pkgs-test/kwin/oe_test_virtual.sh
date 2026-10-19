
#!/usr/bin/bash
# 请填写测试用例描述：测试kwin_wayland --virtual参数

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
    # 测试kwin_wayland --virtual参数
    kwin_wayland --virtual
    CHECK_RESULT $? 0 0 "kwin_wayland --virtual failed"

    # 测试kwin_wayland --virtual参数与--width参数组合
    kwin_wayland --virtual --width 1280
    CHECK_RESULT $? 0 0 "kwin_wayland --virtual --width 1280 failed"

    # 测试kwin_wayland --virtual参数与--height参数组合
    kwin_wayland --virtual --height 1024
    CHECK_RESULT $? 0 0 "kwin_wayland --virtual --height 1024 failed"

    # 测试kwin_wayland --virtual参数与--width和--height参数组合
    kwin_wayland --virtual --width 1280 --height 1024
    CHECK_RESULT $? 0 0 "kwin_wayland --virtual --width 1280 --height 1024 failed"

    # 测试kwin_wayland --virtual参数与--scale参数组合
    kwin_wayland --virtual --scale 2
    CHECK_RESULT $? 0 0 "kwin_wayland --virtual --scale 2 failed"

    # 测试kwin_wayland --virtual参数与--output-count参数组合
    kwin_wayland --virtual --output-count 2
    CHECK_RESULT $? 0 0 "kwin_wayland --virtual --output-count 2 failed"

    # 测试kwin_wayland --virtual参数与--width、--height、--scale和--output-count参数组合
    kwin_wayland --virtual --width 1280 --height 1024 --scale 2 --output-count 2
    CHECK_RESULT $? 0 0 "kwin_wayland --virtual --width 1280 --height 1024 --scale 2 --output-count 2 failed"

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
