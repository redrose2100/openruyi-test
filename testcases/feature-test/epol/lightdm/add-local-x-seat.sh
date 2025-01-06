
#!/usr/bin/bash
# 本测试用例用于测试 lightdm 的 add-local-x-seat 命令

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "lightdm"
    # 准备测试数据等
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 add-local-x-seat 命令的基本用法
    dm-tool add-local-x-seat 10
    CHECK_RESULT $? 0 0 "Failed to add local X seat with display number 10"

    # 测试 add-local-x-seat 命令的其他可能的显示编号
    dm-tool add-local-x-seat 20
    CHECK_RESULT $? 0 0 "Failed to add local X seat with display number 20"

    # 测试 add-local-x-seat 命令的边界情况
    dm-tool add-local-x-seat 0
    CHECK_RESULT $? 0 0 "Failed to add local X seat with display number 0"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "lightdm"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
