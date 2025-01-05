
#!/usr/bin/bash
# 本测试用例用于测试 dwh-vacuum 命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "ovirt-engine-dwh"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 -a 参数
    /usr/bin/dwh-vacuum -a
    CHECK_RESULT $? 0 0 "dwh-vacuum -a failed"

    # 测试 -A 参数
    /usr/bin/dwh-vacuum -A
    CHECK_RESULT $? 0 0 "dwh-vacuum -A failed"

    # 测试 -f 参数
    /usr/bin/dwh-vacuum -f
    CHECK_RESULT $? 0 0 "dwh-vacuum -f failed"

    # 测试 -t 参数
    /usr/bin/dwh-vacuum -t some_table
    CHECK_RESULT $? 0 0 "dwh-vacuum -t some_table failed"

    # 测试 -v 参数
    /usr/bin/dwh-vacuum -v
    CHECK_RESULT $? 0 0 "dwh-vacuum -v failed"

    # 测试 -h 参数
    /usr/bin/dwh-vacuum -h
    CHECK_RESULT $? 0 0 "dwh-vacuum -h failed"

    # 测试参数组合
    /usr/bin/dwh-vacuum -a -v
    CHECK_RESULT $? 0 0 "dwh-vacuum -a -v failed"

    /usr/bin/dwh-vacuum -A -v
    CHECK_RESULT $? 0 0 "dwh-vacuum -A -v failed"

    /usr/bin/dwh-vacuum -f -v
    CHECK_RESULT $? 0 0 "dwh-vacuum -f -v failed"

    /usr/bin/dwh-vacuum -t some_table -v
    CHECK_RESULT $? 0 0 "dwh-vacuum -t some_table -v failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "ovirt-engine-dwh"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
