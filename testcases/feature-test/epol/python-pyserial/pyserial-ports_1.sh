
#!/usr/bin/bash
# 请填写测试用例描述：测试 pyserial-ports 命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "python-pyserial"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试命令的基本用法
    pyserial-ports
    CHECK_RESULT $? 0 0 "pyserial-ports command failed"

    # 测试 -h 参数
    pyserial-ports -h
    CHECK_RESULT $? 0 0 "pyserial-ports -h command failed"

    # 测试 -v 参数
    pyserial-ports -v
    CHECK_RESULT $? 0 0 "pyserial-ports -v command failed"

    # 测试 -q 参数
    pyserial-ports -q
    CHECK_RESULT $? 0 0 "pyserial-ports -q command failed"

    # 测试 -n 参数
    pyserial-ports -n 1
    CHECK_RESULT $? 0 0 "pyserial-ports -n 1 command failed"

    # 测试 -s 参数
    pyserial-ports -s
    CHECK_RESULT $? 0 0 "pyserial-ports -s command failed"

    # 测试 -v 和 -n 参数组合
    pyserial-ports -v -n 1
    CHECK_RESULT $? 0 0 "pyserial-ports -v -n 1 command failed"

    # 测试 -q 和 -n 参数组合
    pyserial-ports -q -n 1
    CHECK_RESULT $? 0 0 "pyserial-ports -q -n 1 command failed"

    # 测试 -s 和 -n 参数组合
    pyserial-ports -s -n 1
    CHECK_RESULT $? 0 0 "pyserial-ports -s -n 1 command failed"

    # 测试正则表达式参数
    pyserial-ports "ttyUSB*"
    CHECK_RESULT $? 0 0 "pyserial-ports 'ttyUSB*' command failed"

    # 测试 -v 和正则表达式参数组合
    pyserial-ports -v "ttyUSB*"
    CHECK_RESULT $? 0 0 "pyserial-ports -v 'ttyUSB*' command failed"

    # 测试 -q 和正则表达式参数组合
    pyserial-ports -q "ttyUSB*"
    CHECK_RESULT $? 0 0 "pyserial-ports -q 'ttyUSB*' command failed"

    # 测试 -s 和正则表达式参数组合
    pyserial-ports -s "ttyUSB*"
    CHECK_RESULT $? 0 0 "pyserial-ports -s 'ttyUSB*' command failed"

    # 测试 -v, -n 和正则表达式参数组合
    pyserial-ports -v -n 1 "ttyUSB*"
    CHECK_RESULT $? 0 0 "pyserial-ports -v -n 1 'ttyUSB*' command failed"

    # 测试 -q, -n 和正则表达式参数组合
    pyserial-ports -q -n 1 "ttyUSB*"
    CHECK_RESULT $? 0 0 "pyserial-ports -q -n 1 'ttyUSB*' command failed"

    # 测试 -s, -n 和正则表达式参数组合
    pyserial-ports -s -n 1 "ttyUSB*"
    CHECK_RESULT $? 0 0 "pyserial-ports -s -n 1 'ttyUSB*' command failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "python-pyserial"
    # 清理测试中间产物文件
    rm -rf ./test_files
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
