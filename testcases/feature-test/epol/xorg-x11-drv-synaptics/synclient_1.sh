
#!/usr/bin/bash
# 请填写测试用例描述：测试synclient命令的基本功能，包括列出当前用户设置、打印版本信息和设置用户参数。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xorg-x11-drv-synaptics"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试列出当前用户设置
    synclient -l
    CHECK_RESULT $? 0 0 "Failed to list current user settings"
    
    # 测试打印版本信息
    synclient -V
    CHECK_RESULT $? 0 0 "Failed to print synclient version string"
    
    # 测试设置用户参数
    synclient TapButton1=1 TapButton2=2
    CHECK_RESULT $? 0 0 "Failed to set user parameters"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "xorg-x11-drv-synaptics"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
