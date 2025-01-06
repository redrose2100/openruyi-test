
#!/usr/bin/bash
# 请填写测试用例描述：测试xfce4-panel-profiles save命令，保存当前配置到指定文件

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xfce4-panel-profiles"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    touch "./test_profile.xfconf"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    xfce4-panel-profiles save "./test_profile.xfconf"
    CHECK_RESULT $? 0 0 "Failed to save panel profile"
    # 检查文件是否存在
    test -f "./test_profile.xfconf"
    CHECK_RESULT $? 0 0 "Profile file not created"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        # 清理测试中间产物文件
    DNF_REMOVE "xfce4-panel-profiles"
    rm -f "./test_profile.xfconf"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
