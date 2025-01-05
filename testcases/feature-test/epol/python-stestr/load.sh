
#!/usr/bin/bash
# 请填写测试用例描述：测试stestr load命令的不同参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "python-stestr"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    touch ./test1.subunit ./test2.subunit
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    stestr-3 load ./test1.subunit
    CHECK_RESULT $? 0 0 "stestr-3 load failed without any optional arguments"

    stestr-3 load --force-init ./test1.subunit
    CHECK_RESULT $? 0 0 "stestr-3 load with --force-init failed"

    stestr-3 load --subunit ./test1.subunit
    CHECK_RESULT $? 0 0 "stestr-3 load with --subunit failed"

    stestr-3 load --id 123 ./test1.subunit
    CHECK_RESULT $? 0 0 "stestr-3 load with --id failed"

    stestr-3 load --subunit-trace ./test1.subunit
    CHECK_RESULT $? 0 0 "stestr-3 load with --subunit-trace failed"

    stestr-3 load --color ./test1.subunit
    CHECK_RESULT $? 0 0 "stestr-3 load with --color failed"

    stestr-3 load --abbreviate ./test1.subunit
    CHECK_RESULT $? 0 0 "stestr-3 load with --abbreviate failed"

    stestr-3 load --suppress-attachments ./test1.subunit
    CHECK_RESULT $? 0 0 "stestr-3 load with --suppress-attachments failed"

    stestr-3 load --all-attachments ./test1.subunit
    CHECK_RESULT $? 0 0 "stestr-3 load with --all-attachments failed"

    stestr-3 load --show-binary-attachments ./test1.subunit
    CHECK_RESULT $? 0 0 "stestr-3 load with --show-binary-attachments failed"

    # Test with all optional arguments except mutually exclusive ones
    stestr-3 load --force-init --subunit --id 123 --subunit-trace --color --abbreviate --suppress-attachments ./test1.subunit
    CHECK_RESULT $? 0 0 "stestr-3 load with all optional arguments except mutually exclusive ones failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        # 清理测试中间产物文件
    DNF_REMOVE "python-stestr"
    rm -f ./test1.subunit ./test2.subunit
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
