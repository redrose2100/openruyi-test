
#!/usr/bin/bash
# 测试用例描述：测试 python-jsonpath-rw 软件包的 jsonpath.py 命令，验证其基本功能和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "python-jsonpath-rw"
    # 准备测试数据
    echo '{"name": "John", "age": 30, "city": "New York"}' > ./test_data.json
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试基本功能
    python3 -m jsonpath_rw.jsonpath '$.name' ./test_data.json
    CHECK_RESULT $? 0 0 "failed to run jsonpath.py with basic expression"
    
    # 测试多个文件
    echo '{"name": "Jane", "age": 25, "city": "Los Angeles"}' > ./test_data2.json
    python3 -m jsonpath_rw.jsonpath '$.name' ./test_data.json ./test_data2.json
    CHECK_RESULT $? 0 0 "failed to run jsonpath.py with multiple files"
    
    # 测试 union 操作
    python3 -m jsonpath_rw.jsonpath '$.name|$.age' ./test_data.json
    CHECK_RESULT $? 0 0 "failed to run jsonpath.py with union operation"
    
    # 测试 array slice
    echo '[{"name": "John", "age": 30}, {"name": "Jane", "age": 25}]' > ./test_data_array.json
    python3 -m jsonpath_rw.jsonpath '$[*].name' ./test_data_array.json
    CHECK_RESULT $? 0 0 "failed to run jsonpath.py with array slice"
    
    # 测试 any field
    python3 -m jsonpath_rw.jsonpath '$.*' ./test_data.json
    CHECK_RESULT $? 0 0 "failed to run jsonpath.py with any field"
    
    # 测试 somewhere in between
    echo '{"person": {"name": "John", "age": 30, "city": "New York"}}' > ./test_data_nested.json
    python3 -m jsonpath_rw.jsonpath '$..name' ./test_data_nested.json
    CHECK_RESULT $? 0 0 "failed to run jsonpath.py with somewhere in between"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "python-jsonpath-rw"
    # 清理测试中间产物文件
    rm -f ./test_data.json ./test_data2.json ./test_data_array.json ./test_data_nested.json
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
