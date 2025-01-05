
#!/usr/bin/bash
# 请填写测试用例描述：测试stestr-3 failing命令，验证其参数功能

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "python-stestr"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    mkdir -p ./test_repo
    cd ./test_repo
    stestr-3 init
    # 创建一些测试文件以确保测试数据存在
    touch test1.py test2.py
    stestr-3 run
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试stestr-3 failing命令的基本功能
    stestr-3 failing
    CHECK_RESULT $? 0 0 "stestr-3 failing command failed"

    # 测试--subunit参数
    stestr-3 failing --subunit
    CHECK_RESULT $? 0 0 "stestr-3 failing --subunit command failed"

    # 测试--list参数
    stestr-3 failing --list
    CHECK_RESULT $? 0 0 "stestr-3 failing --list command failed"

    # 测试--subunit和--list参数组合
    stestr-3 failing --subunit --list
    CHECK_RESULT $? 0 0 "stestr-3 failing --subunit --list command failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "python-stestr"
    # 清理测试中间产物文件
    cd ..
    rm -rf ./test_repo
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
