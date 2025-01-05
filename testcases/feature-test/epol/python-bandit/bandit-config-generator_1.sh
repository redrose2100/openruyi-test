
#!/usr/bin/bash
# 测试用例描述：测试 bandit-config-generator 命令的基本功能，包括生成配置文件、显示默认设置、指定测试和跳过测试。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "python-bandit"
    # 准备测试数据等
    mkdir -p ./test_data
    rm -f ./test_data/example_profile.yaml
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试生成配置文件
    bandit-config-generator -o ./test_data/example_profile.yaml
    CHECK_RESULT $? 0 0 "Failed to generate profile file"
    # 测试显示默认设置
    bandit-config-generator --show-defaults
    CHECK_RESULT $? 0 0 "Failed to show default settings"
    # 测试指定测试
    bandit-config-generator -t B101,B102 -o ./test_data/example_profile.yaml
    CHECK_RESULT $? 0 0 "Failed to specify tests"
    # 测试跳过测试
    bandit-config-generator -s B101,B102 -o ./test_data/example_profile.yaml
    CHECK_RESULT $? 0 0 "Failed to skip tests"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "python-bandit"
    rm -rf ./test_data
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
