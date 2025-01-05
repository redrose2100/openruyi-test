
#!/usr/bin/bash
# 测试用例描述：测试stestr list命令及其参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "python-stestr"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    echo "test1" > ./include_list.txt
    echo "test2" > ./exclude_list.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试stestr list命令及其参数
    stestr-3.9 list --test-path ./tests
    CHECK_RESULT $? 0 0 "stestr list command failed"

    stestr-3.9 list --help --test-path ./tests
    CHECK_RESULT $? 0 0 "stestr list --help command failed"

    stestr-3.9 list --blacklist-file ./exclude_list.txt --test-path ./tests
    CHECK_RESULT $? 0 0 "stestr list --blacklist-file command failed"

    stestr-3.9 list --exclude-list ./exclude_list.txt --test-path ./tests
    CHECK_RESULT $? 0 0 "stestr list --exclude-list command failed"

    stestr-3.9 list --whitelist-file ./include_list.txt --test-path ./tests
    CHECK_RESULT $? 0 0 "stestr list --whitelist-file command failed"

    stestr-3.9 list --include-list ./include_list.txt --test-path ./tests
    CHECK_RESULT $? 0 0 "stestr list --include-list command failed"

    stestr-3.9 list --black-regex "test1" --test-path ./tests
    CHECK_RESULT $? 0 0 "stestr list --black-regex command failed"

    stestr-3.9 list --exclude-regex "test1" --test-path ./tests
    CHECK_RESULT $? 0 0 "stestr list --exclude-regex command failed"

    stestr-3.9 list "test1" --test-path ./tests
    CHECK_RESULT $? 0 0 "stestr list with filter command failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "python-stestr"
    # 清理测试中间产物文件
    rm -f ./include_list.txt ./exclude_list.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
