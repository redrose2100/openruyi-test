
#!/usr/bin/bash
# 测试stestr last命令及其参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "python-stestr"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试stestr last命令及其参数
    stestr-3 last
    CHECK_RESULT $? 0 0 "stestr last command failed"

    stestr-3 last --subunit
    CHECK_RESULT $? 0 0 "stestr last --subunit command failed"

    stestr-3 last --no-subunit-trace
    CHECK_RESULT $? 0 0 "stestr last --no-subunit-trace command failed"

    stestr-3 last --force-subunit-trace
    CHECK_RESULT $? 0 0 "stestr last --force-subunit-trace command failed"

    stestr-3 last --color
    CHECK_RESULT $? 0 0 "stestr last --color command failed"

    stestr-3 last --suppress-attachments
    CHECK_RESULT $? 0 0 "stestr last --suppress-attachments command failed"

    stestr-3 last --all-attachments
    CHECK_RESULT $? 0 0 "stestr last --all-attachments command failed"

    stestr-3 last --show-binary-attachments
    CHECK_RESULT $? 0 0 "stestr last --show-binary-attachments command failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "python-stestr"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
