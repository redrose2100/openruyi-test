
#!/usr/bin/bash
# 本测试用例用于测试botan命令中的uuid子命令，该命令用于生成随机UUID。

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
    # 测试uuid命令的基本用法
    botan uuid
    CHECK_RESULT $? 0 0 "botan uuid command failed"
    # 测试uuid命令的输出是否符合UUID格式
    botan uuid | grep -E '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$'
    CHECK_RESULT $? 0 0 "botan uuid output format is incorrect"
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
