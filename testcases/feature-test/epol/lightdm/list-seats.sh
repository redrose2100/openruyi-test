
#!/usr/bin/bash
# 本测试用例用于测试 lightdm 的 dm-tool list-seats 命令

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "lightdm"
    # 启动 lightdm 服务
    systemctl start lightdm
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 list-seats 命令
    dm-tool list-seats
    CHECK_RESULT $? 0 0 "dm-tool list-seats failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 停止 lightdm 服务
    systemctl stop lightdm
    # 卸载安装的软件包
    DNF_REMOVE "lightdm"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
