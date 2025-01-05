
#!/usr/bin/bash
# 测试用例描述：测试 bandit-baseline 命令的基本功能，包括指定输出格式和检查代码文件

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "python-bandit"
    # 准备测试数据
    echo "def test_function():\n    pass" > ./test_script.py
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试无输出格式指定的情况
    bandit-baseline ./test_script.py
    CHECK_RESULT $? 2 0 "bandit-baseline command failed without output format specified"

    # 测试指定输出格式为 txt 的情况
    bandit-baseline -f txt ./test_script.py > ./output.txt
    CHECK_RESULT $? 2 0 "bandit-baseline command failed with output format txt"

    # 测试指定输出格式为 html 的情况
    bandit-baseline -f html ./test_script.py > ./output.html
    CHECK_RESULT $? 2 0 "bandit-baseline command failed with output format html"

    # 测试指定输出格式为 json 的情况
    bandit-baseline -f json ./test_script.py > ./output.json
    CHECK_RESULT $? 2 0 "bandit-baseline command failed with output format json"

    # 测试带 severity 过滤参数的情况
    bandit-baseline -f txt -ll ./test_script.py > ./output_ll.txt
    CHECK_RESULT $? 2 0 "bandit-baseline command failed with severity filter -ll"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "python-bandit"
    rm -f ./test_script.py ./output.txt ./output.html ./output.json ./output_ll.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
