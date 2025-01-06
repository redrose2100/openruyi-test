
#!/usr/bin/bash
# 测试用例描述：测试 kate-syntax-highlighter 命令的基本功能和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "kf5-syntax-highlighting"
    # 准备测试数据
    echo "print('Hello, World!')" > ./test.py
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试命令的基本用法
    kate-syntax-highlighter ./test.py
    CHECK_RESULT $? 0 0 "kate-syntax-highlighter basic usage failed"

    # 测试 --version 参数
    kate-syntax-highlighter -v
    CHECK_RESULT $? 0 0 "kate-syntax-highlighter --version failed"

    # 测试 --list 参数
    kate-syntax-highlighter -l
    CHECK_RESULT $? 0 0 "kate-syntax-highlighter --list failed"

    # 测试 --list-themes 参数
    kate-syntax-highlighter --list-themes
    CHECK_RESULT $? 0 0 "kate-syntax-highlighter --list-themes failed"

    # 测试 --output 参数
    kate-syntax-highlighter -o ./output.html ./test.py
    CHECK_RESULT $? 0 0 "kate-syntax-highlighter --output failed"

    # 测试 --syntax 参数
    kate-syntax-highlighter -s python ./test.py
    CHECK_RESULT $? 0 0 "kate-syntax-highlighter --syntax failed"

    # 测试 --theme 参数
    kate-syntax-highlighter -t default ./test.py
    CHECK_RESULT $? 0 0 "kate-syntax-highlighter --theme failed"

    # 测试 --output-format 参数
    kate-syntax-highlighter -f ansi ./test.py
    CHECK_RESULT $? 0 0 "kate-syntax-highlighter --output-format failed"

    # 测试 --syntax-trace 参数
    kate-syntax-highlighter --syntax-trace format -f ansi ./test.py
    CHECK_RESULT $? 0 0 "kate-syntax-highlighter --syntax-trace failed"

    # 测试 --no-ansi-background 参数
    kate-syntax-highlighter -b ./test.py
    CHECK_RESULT $? 0 0 "kate-syntax-highlighter --no-ansi-background failed"

    # 测试 --title 参数
    kate-syntax-highlighter -T "Test Title" ./test.py
    CHECK_RESULT $? 0 0 "kate-syntax-highlighter --title failed"

    # 测试 --stdin 参数
    cat ./test.py | kate-syntax-highlighter --stdin -s python
    CHECK_RESULT $? 0 0 "kate-syntax-highlighter --stdin failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "kf5-syntax-highlighting"
    # 清理测试中间产物文件
    rm -f ./test.py ./output.html
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
