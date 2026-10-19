
#!/usr/bin/bash
# 本测试用例用于测试 lightdm 的 switch-to-user 命令，包括基本功能和参数组合。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "lightdm"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    # 创建一个测试用户
    useradd testuser
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 switch-to-user 命令的基本功能
    dm-tool switch-to-user testuser
    CHECK_RESULT $? 0 0 "Failed to switch to user testuser"

    # 测试 switch-to-user 命令的参数组合
    dm-tool switch-to-user testuser gnome
    CHECK_RESULT $? 0 0 "Failed to switch to user testuser with session gnome"

    # 测试 switch-to-user 命令的其他参数组合
    dm-tool switch-to-user testuser --session-bus
    CHECK_RESULT $? 0 0 "Failed to switch to user testuser with session-bus"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "lightdm"
    # 清理测试中间产物文件
    userdel testuser
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
