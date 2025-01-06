
#!/usr/bin/bash
# 测试用例描述：测试 otopi-config-query.py query 命令，验证其参数组合和功能

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "otopi"
    # 准备测试数据
    mkdir -p ./test_config.d
    echo "[environment:default]" > ./test_config.conf
    echo "key1=value1" >> ./test_config.conf
    echo "key2=value2" >> ./test_config.conf
    echo "[section1]" > ./test_config.d/section1.conf
    echo "key3=value3" >> ./test_config.d/section1.conf
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试基本参数组合
    otopi-config-query.py query -k key1 -f ./test_config.conf
    CHECK_RESULT $? 0 0 "failed to query key1"
    # 测试 -t 参数
    otopi-config-query.py query -t -k key1 -f ./test_config.conf
    CHECK_RESULT $? 0 0 "failed to query key1 with type"
    # 测试 -s 参数
    otopi-config-query.py query -s section1 -k key3 -f ./test_config.conf
    CHECK_RESULT $? 0 0 "failed to query key3 in section1"
    # 测试多个配置文件
    otopi-config-query.py query -k key3 -f ./test_config.d
    CHECK_RESULT $? 0 0 "failed to query key3 in directory"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "otopi"
    # 清理测试中间产物文件
    rm -rf ./test_config.conf ./test_config.d
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
