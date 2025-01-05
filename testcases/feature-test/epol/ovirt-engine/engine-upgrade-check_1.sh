
#!/usr/bin/bash
# 本测试用例用于测试 engine-upgrade-check 命令的基本功能，包括帮助信息和安静模式。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "ovirt-engine"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助信息
    engine-upgrade-check -h
    CHECK_RESULT $? 0 0 "Failed to show help message"
    
    # 测试安静模式
    engine-upgrade-check -q
    CHECK_RESULT $? 0 0 "Failed to run in quiet mode"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "ovirt-engine"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
