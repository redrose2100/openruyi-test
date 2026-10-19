
#!/usr/bin/bash
# 请填写测试用例描述：测试dde-api的-version参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "dde-api"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    touch "./help"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试-version参数
    /home/linqian/mugen/dde-api -version
    CHECK_RESULT $? 0 0 "failed to show version"
    # 测试帮助文件是否存在
    test -f "./help"
    CHECK_RESULT $? 0 0 "help file not found"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "dde-api"
    # 清理测试中间产物文件
    rm -f "./help"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
