
#!/usr/bin/bash
# 请填写测试用例描述：测试 mate-dictionary 命令的基本功能和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "mate-utils"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    echo "test" > ./test_word.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 mate-dictionary 命令的基本功能
    mate-dictionary --look-up=test
    CHECK_RESULT $? 0 0 "failed to look up word with --look-up"

    # 测试 mate-dictionary 命令的 --match 参数
    mate-dictionary --match=test
    CHECK_RESULT $? 0 0 "failed to match word with --match"

    # 测试 mate-dictionary 命令的 --source 参数
    mate-dictionary --source=example
    CHECK_RESULT $? 0 0 "failed to use dictionary source with --source"

    # 测试 mate-dictionary 命令的 --no-window 参数
    mate-dictionary --no-window --look-up=test
    CHECK_RESULT $? 0 0 "failed to print result to console with --no-window"

    # 测试 mate-dictionary 命令的 --database 参数
    mate-dictionary --database=example
    CHECK_RESULT $? 0 0 "failed to use database with --database"

    # 测试 mate-dictionary 命令的 --display 参数
    mate-dictionary --display=:0 --look-up=test
    CHECK_RESULT $? 0 0 "failed to use X display with --display"

    # 测试 mate-dictionary 命令的参数组合
    mate-dictionary --look-up=test --source=example --no-window
    CHECK_RESULT $? 0 0 "failed to use combination of parameters"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "mate-utils"
    # 清理测试中间产物文件
    rm -f ./test_word.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
