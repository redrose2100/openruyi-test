
#!/usr/bin/bash
# 本测试用例用于测试 mate-volume-control 命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "mate-media"
    # 准备测试数据等
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 -h 参数
    mate-volume-control -h
    CHECK_RESULT $? 0 0 "failed to show help options with -h"

    # 测试 --help 参数
    mate-volume-control --help
    CHECK_RESULT $? 0 0 "failed to show help options with --help"

    # 测试 --help-all 参数
    mate-volume-control --help-all
    CHECK_RESULT $? 0 0 "failed to show all help options with --help-all"

    # 测试 --help-gtk 参数
    mate-volume-control --help-gtk
    CHECK_RESULT $? 0 0 "failed to show GTK+ options with --help-gtk"

    # 测试 -b 参数
    mate-volume-control -b pulse
    CHECK_RESULT $? 0 0 "failed to set backend to pulse with -b pulse"
    mate-volume-control -b alsa
    CHECK_RESULT $? 0 0 "failed to set backend to alsa with -b alsa"
    mate-volume-control -b oss
    CHECK_RESULT $? 0 0 "failed to set backend to oss with -b oss"
    mate-volume-control -b null
    CHECK_RESULT $? 0 0 "failed to set backend to null with -b null"

    # 测试 -d 参数
    mate-volume-control -d
    CHECK_RESULT $? 0 0 "failed to enable debug with -d"

    # 测试 -p 参数
    mate-volume-control -p effects
    CHECK_RESULT $? 0 0 "failed to set startup page to effects with -p effects"
    mate-volume-control -p hardware
    CHECK_RESULT $? 0 0 "failed to set startup page to hardware with -p hardware"
    mate-volume-control -p input
    CHECK_RESULT $? 0 0 "failed to set startup page to input with -p input"
    mate-volume-control -p output
    CHECK_RESULT $? 0 0 "failed to set startup page to output with -p output"
    mate-volume-control -p applications
    CHECK_RESULT $? 0 0 "failed to set startup page to applications with -p applications"

    # 测试 -v 参数
    mate-volume-control -v
    CHECK_RESULT $? 0 0 "failed to show version with -v"

    # 测试 --display 参数
    mate-volume-control --display=:0
    CHECK_RESULT $? 0 0 "failed to set display with --display=:0"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "mate-media"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
