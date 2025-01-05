
#!/usr/bin/bash
# 请填写测试用例描述：测试botan cpuid命令，检查是否能够正确列出处理器标志

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试cpuid命令
    botan cpuid
    CHECK_RESULT $? 0 0 "botan cpuid command failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "botan2"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
