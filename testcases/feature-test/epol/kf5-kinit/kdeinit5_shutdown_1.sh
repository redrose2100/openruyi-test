
#!/usr/bin/bash
# 测试kf5-kinit软件包中的kdeinit5_shutdown命令

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "kf5-kinit"
    # 设置DISPLAY环境变量
    export DISPLAY=:0
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试kdeinit5_shutdown命令
    kdeinit5_shutdown
    CHECK_RESULT $? 0 0 "kdeinit5_shutdown command failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "kf5-kinit"
    # 清理环境变量
    unset DISPLAY
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
