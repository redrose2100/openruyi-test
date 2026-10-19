
#!/usr/bin/bash
# 请填写测试用例描述：测试mb2org命令的各种参数组合和默认行为

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "fcitx"
    # 准备测试数据
    touch "./pyusrphrase.mb"
    touch "./pybase.mb"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试默认行为
    mb2org -f ~/.fcitx/pyusrphrase.mb -b /usr/share/fcitx/pinyin/pybase.mb
    CHECK_RESULT $? 0 0 "mb2org default behavior failed"

    # 测试-f参数
    mb2org -f "./pyusrphrase.mb"
    CHECK_RESULT $? 0 0 "mb2org -f parameter failed"

    # 测试-b参数
    mb2org -b "./pybase.mb"
    CHECK_RESULT $? 0 0 "mb2org -b parameter failed"

    # 测试-s参数
    mb2org -s
    CHECK_RESULT $? 0 0 "mb2org -s parameter failed"

    # 测试-f和-b参数组合
    mb2org -f "./pyusrphrase.mb" -b "./pybase.mb"
    CHECK_RESULT $? 0 0 "mb2org -f and -b parameters combination failed"

    # 测试-f、-b和-s参数组合
    mb2org -f "./pyusrphrase.mb" -b "./pybase.mb" -s
    CHECK_RESULT $? 0 0 "mb2org -f, -b and -s parameters combination failed"

    # 测试-h参数
    mb2org -h | grep "usage: mb2org"
    CHECK_RESULT $? 0 0 "mb2org -h parameter failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "fcitx"
    # 清理测试中间产物文件
    rm -f "./pyusrphrase.mb"
    rm -f "./pybase.mb"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
