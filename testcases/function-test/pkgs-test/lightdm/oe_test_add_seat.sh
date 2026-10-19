
#!/usr/bin/bash
# 本测试用例用于测试 lightdm 的 dm-tool add-seat 命令

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
    # 测试 add-seat 命令的基本用法
    dm-tool add-seat type1
    CHECK_RESULT $? 0 0 "Failed to add seat with type1"

    # 测试 add-seat 命令的参数组合
    dm-tool add-seat type2 NAME=value1
    CHECK_RESULT $? 0 0 "Failed to add seat with type2 and NAME=value1"

    # 测试 add-seat 命令的多个参数组合
    dm-tool add-seat type3 NAME=value2 OTHER=value3
    CHECK_RESULT $? 0 0 "Failed to add seat with type3, NAME=value2, and OTHER=value3"

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
