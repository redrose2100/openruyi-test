
#!/usr/bin/bash
# 请填写测试用例描述：测试 nmstatectl show 命令，验证其输出内容是否符合预期

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "nmstate"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 nmstatectl show 命令
    nmstatectl show
    CHECK_RESULT $? 0 0 "nmstatectl show command failed"
    # 验证输出内容是否包含预期的关键字
    nmstatectl show | grep "dns-resolver"
    CHECK_RESULT $? 0 0 "dns-resolver not found in output"
    nmstatectl show | grep "route-rules"
    CHECK_RESULT $? 0 0 "route-rules not found in output"
    nmstatectl show | grep "routes"
    CHECK_RESULT $? 0 0 "routes not found in output"
    nmstatectl show | grep "interfaces"
    CHECK_RESULT $? 0 0 "interfaces not found in output"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "nmstate"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
