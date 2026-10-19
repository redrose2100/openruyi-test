
#!/usr/bin/bash
# 测试用例描述：测试 python-dulwich 软件包的安装、卸载和版本信息

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "python-dulwich"
    # 检查安装是否成功
    python3 -c "import dulwich; print(dulwich.__version__)"
    CHECK_RESULT $? 0 0 "Failed to import dulwich"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试版本信息
    python3 -c "import dulwich; print(dulwich.__version__)"
    CHECK_RESULT $? 0 0 "Failed to get dulwich version"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "python-dulwich"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
