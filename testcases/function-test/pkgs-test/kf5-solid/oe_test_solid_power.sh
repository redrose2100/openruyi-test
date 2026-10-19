
#!/usr/bin/bash
# 请填写测试用例描述：测试kf5-solid软件包中的solid-power命令，验证不被识别的命令参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "kf5-solid"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试不被识别的命令参数
    solid-power --invalid-command
    CHECK_RESULT $? 1 0 "Command '--invalid-command' should not be recognized"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "kf5-solid"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
