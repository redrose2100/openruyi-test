
#!/usr/bin/bash
# 请填写测试用例描述：测试 xscreensaver-command -lock 命令

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xscreensaver"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    export DISPLAY=:0.0  # 设置DISPLAY环境变量以避免错误
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 xscreensaver-command -lock 命令
    xscreensaver-command -lock
    CHECK_RESULT $? 0 0 "xscreensaver-command -lock failed"

    # 测试 xscreensaver-command -lock 命令在屏幕已锁定情况下的行为
    xscreensaver-command -lock
    CHECK_RESULT $? 0 0 "xscreensaver-command -lock failed when screen is already locked"

    # 测试 xscreensaver-command -lock 命令在屏幕未锁定情况下的行为
    xscreensaver-command -deactivate
    xscreensaver-command -lock
    CHECK_RESULT $? 0 0 "xscreensaver-command -lock failed when screen is not locked"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "xscreensaver"
    # 清理测试中间产物文件
    unset DISPLAY  # 清理环境变量
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
