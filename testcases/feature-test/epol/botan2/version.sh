
#!/usr/bin/bash
# 请填写测试用例描述：测试botan version命令，验证其输出版本信息

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
    # 测试version命令的基本用法
    botan version
    CHECK_RESULT $? 0 0 "botan version command failed"
    
    # 测试version命令的--full参数
    botan version --full
    CHECK_RESULT $? 0 0 "botan version --full command failed"
    
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
