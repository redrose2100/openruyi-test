
#!/usr/bin/bash
# 测试 xscreensaver-command -activate 命令

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
    # 测试 xscreensaver-command -activate 命令
    xscreensaver-command -activate
    CHECK_RESULT $? 0 0 "xscreensaver-command -activate failed"

    # 测试 xscreensaver-command -quiet -activate 命令
    xscreensaver-command -quiet -activate
    CHECK_RESULT $? 0 0 "xscreensaver-command -quiet -activate failed"

    # 测试 xscreensaver-command -verbose -activate 命令
    xscreensaver-command -verbose -activate
    CHECK_RESULT $? 0 0 "xscreensaver-command -verbose -activate failed"

    # 测试 xscreensaver-command -deactivate -activate 命令
    xscreensaver-command -deactivate
    xscreensaver-command -activate
    CHECK_RESULT $? 0 0 "xscreensaver-command -deactivate -activate failed"

    # 测试 xscreensaver-command -lock -activate 命令
    xscreensaver-command -lock
    xscreensaver-command -activate
    CHECK_RESULT $? 0 0 "xscreensaver-command -lock -activate failed"

    # 测试 xscreensaver-command -cycle -activate 命令
    xscreensaver-command -cycle
    xscreensaver-command -activate
    CHECK_RESULT $? 0 0 "xscreensaver-command -cycle -activate failed"

    # 测试 xscreensaver-command -next -activate 命令
    xscreensaver-command -next
    xscreensaver-command -activate
    CHECK_RESULT $? 0 0 "xscreensaver-command -next -activate failed"

    # 测试 xscreensaver-command -prev -activate 命令
    xscreensaver-command -prev
    xscreensaver-command -activate
    CHECK_RESULT $? 0 0 "xscreensaver-command -prev -activate failed"

    # 测试 xscreensaver-command -select 1 -activate 命令
    xscreensaver-command -select 1
    xscreensaver-command -activate
    CHECK_RESULT $? 0 0 "xscreensaver-command -select 1 -activate failed"

    # 测试 xscreensaver-command -suspend -activate 命令
    xscreensaver-command -suspend
    xscreensaver-command -activate
    CHECK_RESULT $? 0 0 "xscreensaver-command -suspend -activate failed"

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
