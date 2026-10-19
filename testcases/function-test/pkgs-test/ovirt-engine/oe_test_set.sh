
#!/usr/bin/bash
# 本测试用例用于测试 ovirt-engine 的 engine-config 命令的 set 功能

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "ovirt-engine"
    # 准备测试数据等
    echo "test_value" > ./test_value_file
    touch ./test_properties_file
    touch ./test_config_file
    touch ./test_log_file
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 set 命令的基本用法
    engine-config -s TestKey=test_value
    CHECK_RESULT $? 0 0 "Failed to set configuration key with -s option"

    # 测试 set 命令使用文件设置值
    engine-config -s TestKey=./test_value_file
    CHECK_RESULT $? 0 0 "Failed to set configuration key with file"

    # 测试 set 命令使用 --set 选项
    engine-config --set TestKey=test_value
    CHECK_RESULT $? 0 0 "Failed to set configuration key with --set option"

    # 测试 set 命令使用 --set 选项和文件设置值
    engine-config --set TestKey=./test_value_file
    CHECK_RESULT $? 0 0 "Failed to set configuration key with --set option and file"

    # 测试 set 命令使用 --cver 选项
    engine-config -s TestKey=test_value --cver=1.0
    CHECK_RESULT $? 0 0 "Failed to set configuration key with --cver option"

    # 测试 set 命令使用 --properties 选项
    engine-config -s TestKey=test_value --properties=./test_properties_file
    CHECK_RESULT $? 0 0 "Failed to set configuration key with --properties option"

    # 测试 set 命令使用 --config 选项
    engine-config -s TestKey=test_value --config=./test_config_file
    CHECK_RESULT $? 0 0 "Failed to set configuration key with --config option"

    # 测试 set 命令使用 --log-file 选项
    engine-config -s TestKey=test_value --log-file=./test_log_file
    CHECK_RESULT $? 0 0 "Failed to set configuration key with --log-file option"

    # 测试 set 命令使用 --log-level 选项
    engine-config -s TestKey=test_value --log-level=INFO
    CHECK_RESULT $? 0 0 "Failed to set configuration key with --log-level option"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "ovirt-engine"
    # 清理测试中间产物文件
    rm -f ./test_value_file ./test_properties_file ./test_config_file ./test_log_file
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
