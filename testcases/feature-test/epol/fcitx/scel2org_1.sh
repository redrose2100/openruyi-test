
#!/usr/bin/bash
# 测试用例描述：测试 scel2org 命令的基本功能，包括使用不同的参数组合进行转换

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "fcitx"
    # 准备测试数据
    echo "测试数据" > ./test.scel
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试无参数情况
    scel2org ./test.scel
    CHECK_RESULT $? 0 0 "scel2org failed without parameters"

    # 测试 -a 参数
    scel2org -a ./test.scel
    CHECK_RESULT $? 0 0 "scel2org failed with -a parameter"

    # 测试 -o 参数
    scel2org -o ./output.org ./test.scel
    CHECK_RESULT $? 0 0 "scel2org failed with -o parameter"

    # 测试 -a 和 -o 参数组合
    scel2org -a -o ./output.org ./test.scel
    CHECK_RESULT $? 0 0 "scel2org failed with -a and -o parameters"

    # 测试 -h 参数
    scel2org -h > /dev/null
    CHECK_RESULT $? 0 0 "scel2org failed with -h parameter"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "fcitx"
    # 清理测试中间产物文件
    rm -f ./test.scel ./output.org
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
