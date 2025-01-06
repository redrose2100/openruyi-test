
#!/usr/bin/bash
# 本测试用例用于测试otopi-config-query.py的match命令，验证其参数组合和参数顺序的正确性

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
    echo "key1:string:value1" >> ./test_config.conf
    echo "key2:int:42" >> ./test_config.d/test_config1.conf
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试match命令的基本用法
    otopi-config-query.py match -k key1 -v "string:value1" -f ./test_config.conf
    CHECK_RESULT $? 0 0 "match command failed with basic parameters"
    
    # 测试match命令的section参数
    otopi-config-query.py match -s "environment:default" -k key1 -v "string:value1" -f ./test_config.conf
    CHECK_RESULT $? 0 0 "match command failed with section parameter"
    
    # 测试match命令的value参数
    otopi-config-query.py match -k key2 -v "int:42" -f ./test_config.d
    CHECK_RESULT $? 0 0 "match command failed with value parameter"
    
    # 测试match命令的文件目录参数
    otopi-config-query.py match -k key2 -v "int:42" -f ./test_config.d
    CHECK_RESULT $? 0 0 "match command failed with directory parameter"
    
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
