
#!/usr/bin/bash
# 请填写测试用例描述：测试fcitx命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "fcitx"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 -v 参数
    fcitx -v
    CHECK_RESULT $? 0 0 "fcitx -v failed"

    # 测试 --version 参数
    fcitx --version
    CHECK_RESULT $? 0 0 "fcitx --version failed"

    # 测试 -r 参数
    fcitx -r
    CHECK_RESULT $? 0 0 "fcitx -r failed"

    # 测试 --replace 参数
    fcitx --replace
    CHECK_RESULT $? 0 0 "fcitx --replace failed"

    # 测试 -d 参数
    fcitx -d
    CHECK_RESULT $? 0 0 "fcitx -d failed"

    # 测试 -D 参数
    fcitx -D
    CHECK_RESULT $? 0 0 "fcitx -D failed"

    # 测试 -s 参数
    fcitx -s 5
    CHECK_RESULT $? 0 0 "fcitx -s 5 failed"

    # 测试 --ui 参数
    fcitx --ui gtk3
    CHECK_RESULT $? 0 0 "fcitx --ui gtk3 failed"

    # 测试 --enable 参数
    fcitx --enable addon1,addon2
    CHECK_RESULT $? 0 0 "fcitx --enable addon1,addon2 failed"

    # 测试 --disable 参数
    fcitx --disable addon1,addon2
    CHECK_RESULT $? 0 0 "fcitx --disable addon1,addon2 failed"

    # 测试 --disable all 参数
    fcitx --disable all
    CHECK_RESULT $? 0 0 "fcitx --disable all failed"

    # 测试 -h 参数
    fcitx -h
    CHECK_RESULT $? 0 0 "fcitx -h failed"

    # 测试 --help 参数
    fcitx --help
    CHECK_RESULT $? 0 0 "fcitx --help failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "fcitx"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
