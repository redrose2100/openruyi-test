
#!/usr/bin/bash
# 请填写测试用例描述：测试 xscreensaver-command -select 命令，确保其能够正确激活指定编号的屏幕保护程序。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xscreensaver"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    export DISPLAY=:0.0
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 xscreensaver-command -select 命令
    xscreensaver-command -select 1
    CHECK_RESULT $? 0 0 "Failed to activate screensaver with -select 1"

    xscreensaver-command -select 2
    CHECK_RESULT $? 0 0 "Failed to activate screensaver with -select 2"

    xscreensaver-command -select 3
    CHECK_RESULT $? 0 0 "Failed to activate screensaver with -select 3"

    # 测试错误情况
    xscreensaver-command -select 0
    CHECK_RESULT $? 1 0 "Unexpected success with -select 0"

    xscreensaver-command -select 100
    CHECK_RESULT $? 1 0 "Unexpected success with -select 100"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "xscreensaver"
    # 清理测试中间产物文件
    unset DISPLAY
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
