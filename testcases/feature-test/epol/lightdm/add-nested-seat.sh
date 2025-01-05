
#!/usr/bin/bash
# 本测试用例用于测试 lightdm 的 add-nested-seat 命令，包括其参数组合和行为。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "lightdm"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 add-nested-seat 命令的基本用法
    dm-tool add-nested-seat
    CHECK_RESULT $? 0 0 "add-nested-seat command failed without options"

    # 测试 --fullscreen 参数
    dm-tool add-nested-seat --fullscreen
    CHECK_RESULT $? 0 0 "add-nested-seat --fullscreen command failed"

    # 测试 --screen 参数
    dm-tool add-nested-seat --screen "1024x768"
    CHECK_RESULT $? 0 0 "add-nested-seat --screen command failed"

    # 测试 --fullscreen 和 --screen 参数组合
    dm-tool add-nested-seat --fullscreen --screen "1024x768"
    CHECK_RESULT $? 0 0 "add-nested-seat --fullscreen --screen command failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "lightdm"
    # 清理测试中间产物文件
    rm -rf ./test_files
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
