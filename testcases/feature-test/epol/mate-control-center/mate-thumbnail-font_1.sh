
#!/usr/bin/bash
# 测试用例描述：测试 mate-thumbnail-font 命令的基本功能和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "mate-control-center"
    # 准备测试数据
    touch "./test_font.ttf"
    touch "./output.png"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试命令的基本用法
    mate-thumbnail-font "./test_font.ttf" "./output.png"
    CHECK_RESULT $? 0 0 "mate-thumbnail-font basic usage failed"

    # 测试 --text 参数
    mate-thumbnail-font --text="Hello" "./test_font.ttf" "./output.png"
    CHECK_RESULT $? 0 0 "mate-thumbnail-font --text parameter failed"

    # 测试 --size 参数
    mate-thumbnail-font --size=256 "./test_font.ttf" "./output.png"
    CHECK_RESULT $? 0 0 "mate-thumbnail-font --size parameter failed"

    # 测试 --text 和 --size 参数组合
    mate-thumbnail-font --text="Hello" --size=256 "./test_font.ttf" "./output.png"
    CHECK_RESULT $? 0 0 "mate-thumbnail-font --text and --size parameters combination failed"

    # 测试 --help 参数
    mate-thumbnail-font --help
    CHECK_RESULT $? 0 0 "mate-thumbnail-font --help parameter failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "mate-control-center"
    # 清理测试中间产物文件
    rm -f "./test_font.ttf"
    rm -f "./output.png"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
