
#!/usr/bin/bash
# 本测试用例用于测试 oVirt Engine Extension API test tool 的 help 模块

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "ovirt-engine"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 help 模块
    /usr/bin/ovirt-engine-extensions-tool help
    CHECK_RESULT $? 0 0 "help module test failed"
    # 测试 --help 参数
    /usr/bin/ovirt-engine-extensions-tool --help
    CHECK_RESULT $? 0 0 "--help parameter test failed"
    # 测试 --version 参数
    /usr/bin/ovirt-engine-extensions-tool --version
    CHECK_RESULT $? 0 0 "--version parameter test failed"
    # 测试 --log-level 参数
    /usr/bin/ovirt-engine-extensions-tool --log-level=INFO help
    CHECK_RESULT $? 0 0 "--log-level parameter test failed"
    # 测试 --log-file 参数
    /usr/bin/ovirt-engine-extensions-tool --log-file=./ovirt-engine-extensions-tool.log help
    CHECK_RESULT $? 0 0 "--log-file parameter test failed"
    # 测试 --extension-file 参数
    touch ./test-extension-file.xml
    /usr/bin/ovirt-engine-extensions-tool --extension-file=./test-extension-file.xml help
    CHECK_RESULT $? 0 0 "--extension-file parameter test failed"
    # 测试 --extensions-dir 参数
    mkdir -p ./test-extensions-dir
    /usr/bin/ovirt-engine-extensions-tool --extensions-dir=./test-extensions-dir help
    CHECK_RESULT $? 0 0 "--extensions-dir parameter test failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    DNF_REMOVE "ovirt-engine"
    # 清理测试中间产物文件
    rm -f ./test-extension-file.xml
    rm -rf ./test-extensions-dir
    rm -f ./ovirt-engine-extensions-tool.log
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
