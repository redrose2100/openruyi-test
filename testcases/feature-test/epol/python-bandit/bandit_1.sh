
#!/usr/bin/bash
# 测试用例描述：测试 bandit 命令的基本功能，包括递归扫描、输出格式、过滤级别等参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "python3-bandit"
    # 准备测试数据
    mkdir -p ./test_dir
    touch ./test_dir/test_file.py
    echo "import os" > ./test_dir/test_file.py
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试基本功能
    bandit -r ./test_dir
    CHECK_RESULT $? 0 0 "bandit command failed"

    # 测试递归扫描
    bandit -r ./test_dir -f json -o ./output.json
    CHECK_RESULT $? 0 0 "bandit recursive scan failed"

    # 测试输出格式
    bandit -r ./test_dir -f csv
    CHECK_RESULT $? 0 0 "bandit csv output failed"

    # 测试过滤级别
    bandit -r ./test_dir -l -i
    CHECK_RESULT $? 0 0 "bandit severity and confidence filtering failed"

    # 测试自定义输出模板
    bandit -r ./test_dir -f custom --msg-template "{abspath}:{line}: {test_id}[bandit]: {severity}: {msg}"
    CHECK_RESULT $? 0 0 "bandit custom output template failed"

    # 测试排除路径
    bandit -r ./test_dir -x ./test_dir/test_file.py
    CHECK_RESULT $? 0 0 "bandit exclude path failed"

    # 测试基线报告
    touch ./baseline.json
    bandit -r ./test_dir -b ./baseline.json
    CHECK_RESULT $? 0 0 "bandit baseline report failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "python3-bandit"
    rm -rf ./test_dir
    rm -f ./output.json
    rm -f ./baseline.json
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
