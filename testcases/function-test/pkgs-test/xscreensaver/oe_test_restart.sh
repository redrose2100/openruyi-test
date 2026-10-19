
#!/usr/bin/bash
# 测试用例描述：测试 xscreensaver-command -restart 命令

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xscreensaver"
    # 设置 DISPLAY 环境变量
    export DISPLAY=:0.0
    # 启动 xscreensaver 进程
    xscreensaver &
    sleep 5  # 等待 xscreensaver 进程启动
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 xscreensaver-command -restart 命令
    xscreensaver-command -restart
    CHECK_RESULT $? 0 0 "xscreensaver-command -restart failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "xscreensaver"
    # 清理测试中间产物文件
    killall xscreensaver
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
