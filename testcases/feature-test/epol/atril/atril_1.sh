
#!/usr/bin/bash
# 测试 Atril 命令的基本功能和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "atril"
    # 准备测试数据
    touch "./test.pdf"
    # 设置虚拟的 X 显示环境
    export DISPLAY=:99.0
    Xvfb :99 -screen 0 1024x768x24 &
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试命令的基本用法
    atril "./test.pdf"
    CHECK_RESULT $? 0 0 "atril failed to open the file"

    # 测试 -p 参数
    atril -p "1" "./test.pdf"
    CHECK_RESULT $? 0 0 "atril failed to open the file with -p option"

    # 测试 -i 参数
    atril -i "1" "./test.pdf"
    CHECK_RESULT $? 0 0 "atril failed to open the file with -i option"

    # 测试 -f 参数
    atril -f "./test.pdf"
    CHECK_RESULT $? 0 0 "atril failed to open the file in fullscreen mode"

    # 测试 -n 参数
    atril -n "dest1" "./test.pdf"
    CHECK_RESULT $? 0 0 "atril failed to open the file with -n option"

    # 测试 -s 参数
    atril -s "./test.pdf"
    CHECK_RESULT $? 0 0 "atril failed to open the file in presentation mode"

    # 测试 -w 参数
    atril -w "./test.pdf"
    CHECK_RESULT $? 0 0 "atril failed to open the file as a previewer"

    # 测试 -l 参数
    atril -l "test" "./test.pdf"
    CHECK_RESULT $? 0 0 "atril failed to open the file with -l option"

    # 测试 --display 参数
    atril --display ":99" "./test.pdf"
    CHECK_RESULT $? 0 0 "atril failed to open the file with --display option"

    # 测试多个参数组合
    atril -f -s -w -l "test" --display ":99" -p "1" -i "1" -n "dest1" "./test.pdf"
    CHECK_RESULT $? 0 0 "atril failed to open the file with multiple options"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "atril"
    # 清理测试中间产物文件
    rm -f "./test.pdf"
    # 停止虚拟的 X 显示环境
    pkill Xvfb
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
