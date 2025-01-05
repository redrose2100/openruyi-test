
#!/usr/bin/bash
# 本测试用例用于测试 lightdm 的 switch-to-guest 命令

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "lightdm"
    # 创建一个临时的seat环境变量
    export XDG_SEAT_PATH="/tmp/seat0"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 switch-to-guest 命令的基本用法
    dm-tool switch-to-guest
    CHECK_RESULT $? 0 0 "Failed to switch to guest session"

    # 测试 switch-to-guest 命令带参数 SESSION 的用法
    dm-tool switch-to-guest "gnome"
    CHECK_RESULT $? 0 0 "Failed to switch to guest session with specified session"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "lightdm"
    # 清理环境变量
    unset XDG_SEAT_PATH
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
