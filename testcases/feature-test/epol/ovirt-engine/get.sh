
#!/usr/bin/bash
# 本测试用例用于测试 engine-config 命令的 -g 和 --get 参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "ovirt-engine"
    # 准备测试数据等
    # 创建一个测试配置文件
    echo "TestKey=TestValue" > ./test.properties
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 -g 参数
    engine-config -g TestKey
    CHECK_RESULT $? 0 0 "engine-config -g TestKey failed"

    # 测试 --get 参数
    engine-config --get=TestKey
    CHECK_RESULT $? 0 0 "engine-config --get=TestKey failed"

    # 测试 -g 参数和 --cver 参数
    engine-config -g TestKey --cver=general
    CHECK_RESULT $? 0 0 "engine-config -g TestKey --cver=general failed"

    # 测试 --get 参数和 --cver 参数
    engine-config --get=TestKey --cver=general
    CHECK_RESULT $? 0 0 "engine-config --get=TestKey --cver=general failed"

    # 测试 -g 参数和 --properties 参数
    engine-config -g TestKey --properties=./test.properties
    CHECK_RESULT $? 0 0 "engine-config -g TestKey --properties=./test.properties failed"

    # 测试 --get 参数和 --properties 参数
    engine-config --get=TestKey --properties=./test.properties
    CHECK_RESULT $? 0 0 "engine-config --get=TestKey --properties=./test.properties failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "ovirt-engine"
    # 清理测试中间产物文件
    rm -f ./test.properties
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
