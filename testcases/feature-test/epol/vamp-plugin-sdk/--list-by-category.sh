
#!/usr/bin/bash
# 请填写测试用例描述：测试vamp-simple-host命令的--list-by-category参数，该参数用于列出插件索引按类别分类的机器可读格式。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "vamp-plugin-sdk"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试vamp-simple-host --list-by-category命令
    vamp-simple-host --list-by-category
    CHECK_RESULT $? 0 0 "vamp-simple-host --list-by-category failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "vamp-plugin-sdk"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
