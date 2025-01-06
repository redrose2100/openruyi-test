
#!/usr/bin/bash
# 本测试用例用于测试 ovirt-engine 的 engine-config 命令的 merge 参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "ovirt-engine"
    # 准备测试数据
    echo "test_value" > ./test_value_file
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 merge 参数
    engine-config -m TestKey=test_value --cver=general
    CHECK_RESULT $? 0 0 "engine-config -m TestKey=test_value --cver=general failed"

    # 测试 merge 参数，使用文件中的值
    engine-config -m TestKey=./test_value_file --cver=general
    CHECK_RESULT $? 0 0 "engine-config -m TestKey=./test_value_file --cver=general failed"

    # 测试 merge 参数，使用不同的配置文件
    engine-config -m TestKey=test_value --config=./test_config_file --cver=general
    CHECK_RESULT $? 0 0 "engine-config -m TestKey=test_value --config=./test_config_file --cver=general failed"

    # 测试 merge 参数，使用不同的日志级别
    engine-config -m TestKey=test_value --log-level=INFO --cver=general
    CHECK_RESULT $? 0 0 "engine-config -m TestKey=test_value --log-level=INFO --cver=general failed"

    # 测试 merge 参数，使用不同的日志文件
    engine-config -m TestKey=test_value --log-file=./test_log_file --cver=general
    CHECK_RESULT $? 0 0 "engine-config -m TestKey=test_value --log-file=./test_log_file --cver=general failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "ovirt-engine"
    # 清理测试中间产物文件
    rm -f ./test_value_file ./test_config_file ./test_log_file
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
