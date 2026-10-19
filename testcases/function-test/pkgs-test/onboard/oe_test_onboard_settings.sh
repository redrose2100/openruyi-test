
#!/usr/bin/bash
# 本测试用例用于测试onboard-settings命令的基本功能和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "onboard"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    touch ./test_layout.onboard
    touch ./test_theme.theme
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试命令的基本用法
    onboard-settings -h
    CHECK_RESULT $? 0 0 "failed to run onboard-settings -h"

    # 测试General Options参数
    onboard-settings -l ./test_layout.onboard
    CHECK_RESULT $? 0 0 "failed to run onboard-settings -l ./test_layout.onboard"
    onboard-settings -t ./test_theme.theme
    CHECK_RESULT $? 0 0 "failed to run onboard-settings -t ./test_theme.theme"
    onboard-settings -s 800x600
    CHECK_RESULT $? 0 0 "failed to run onboard-settings -s 800x600"
    onboard-settings -x 100 -y 100
    CHECK_RESULT $? 0 0 "failed to run onboard-settings -x 100 -y 100"

    # 测试Advanced Options参数
    onboard-settings -e
    CHECK_RESULT $? 0 0 "failed to run onboard-settings -e"
    onboard-settings -m
    CHECK_RESULT $? 0 0 "failed to run onboard-settings -m"
    onboard-settings --not-show-in=GNOME
    CHECK_RESULT $? 0 0 "failed to run onboard-settings --not-show-in=GNOME"
    onboard-settings -D 5.0
    CHECK_RESULT $? 0 0 "failed to run onboard-settings -D 5.0"
    onboard-settings -a
    CHECK_RESULT $? 0 0 "failed to run onboard-settings -a"
    onboard-settings -q metacity
    CHECK_RESULT $? 0 0 "failed to run onboard-settings -q metacity"

    # 测试Debug Options参数
    onboard-settings -d all
    CHECK_RESULT $? 0 0 "failed to run onboard-settings -d all"
    onboard-settings --launched-by=unity-greeter
    CHECK_RESULT $? 0 0 "failed to run onboard-settings --launched-by=unity-greeter"
    onboard-settings -g
    CHECK_RESULT $? 0 0 "failed to run onboard-settings -g"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "onboard"
    # 清理测试中间产物文件
    rm -f ./test_layout.onboard ./test_theme.theme
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
