
#!/usr/bin/bash
# 请填写测试用例描述：测试atril-thumbnailer命令的基本功能和参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "atril"
    # 准备测试数据
    touch "./test_input.pdf"
    touch "./test_output.png"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助选项
    atril-thumbnailer --help
    CHECK_RESULT $? 0 0 "failed to show help options"

    # 测试基本功能
    atril-thumbnailer "./test_input.pdf" "./test_output.png"
    CHECK_RESULT $? 0 0 "failed to generate thumbnail"

    # 测试--size参数
    atril-thumbnailer -s 100 "./test_input.pdf" "./test_output.png"
    CHECK_RESULT $? 0 0 "failed to generate thumbnail with size parameter"

    # 测试--no-limit参数
    atril-thumbnailer -l "./test_input.pdf" "./test_output.png"
    CHECK_RESULT $? 0 0 "failed to generate thumbnail with no-limit parameter"

    # 测试--size和--no-limit参数组合
    atril-thumbnailer -s 100 -l "./test_input.pdf" "./test_output.png"
    CHECK_RESULT $? 0 0 "failed to generate thumbnail with size and no-limit parameters"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "atril"
    # 清理测试中间产物文件
    rm -f "./test_input.pdf"
    rm -f "./test_output.png"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
