
#!/usr/bin/bash
# 请填写测试用例描述：测试botan命令中的cpu_clock子命令

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
    # 测试cpu_clock命令的基本用法
    botan cpu_clock --test-duration=500
    CHECK_RESULT $? 0 0 "botan cpu_clock command failed"
    # 测试cpu_clock命令的其他参数组合
    botan cpu_clock --test-duration=1000
    CHECK_RESULT $? 0 0 "botan cpu_clock command with --test-duration=1000 failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "botan2"
    # 清理测试中间产物文件
    rm -rf ./test_file*
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
