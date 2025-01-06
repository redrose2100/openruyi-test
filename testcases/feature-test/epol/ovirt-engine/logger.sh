
#!/usr/bin/bash
# 本测试用例用于测试 oVirt Engine Extension API 的 logger 模块及其相关参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "ovirt-engine"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    touch ./test-extension.xml
    mkdir ./test-extensions-dir
    touch ./test-log-file.log
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 logger 模块的基本用法
    /usr/bin/ovirt-engine-extensions-tool logger log-record
    CHECK_RESULT $? 0 0 "logger log-record failed"

    # 测试 --extension-file 参数
    /usr/bin/ovirt-engine-extensions-tool --extension-file=./test-extension.xml logger log-record
    CHECK_RESULT $? 0 0 "logger log-record with --extension-file failed"

    # 测试 --extensions-dir 参数
    /usr/bin/ovirt-engine-extensions-tool --extensions-dir=./test-extensions-dir logger log-record
    CHECK_RESULT $? 0 0 "logger log-record with --extensions-dir failed"

    # 测试 --log-file 参数
    /usr/bin/ovirt-engine-extensions-tool --log-file=./test-log-file.log logger log-record
    CHECK_RESULT $? 0 0 "logger log-record with --log-file failed"

    # 测试 --log-level 参数
    /usr/bin/ovirt-engine-extensions-tool --log-level=DEBUG logger log-record
    CHECK_RESULT $? 0 0 "logger log-record with --log-level failed"

    # 测试 --help 参数
    /usr/bin/ovirt-engine-extensions-tool logger --help
    CHECK_RESULT $? 0 0 "logger --help failed"

    # 测试 --version 参数
    /usr/bin/ovirt-engine-extensions-tool --version
    CHECK_RESULT $? 0 0 "--version failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "ovirt-engine"
    # 清理测试中间产物文件
    rm -f ./test-extension.xml
    rm -rf ./test-extensions-dir
    rm -f ./test-log-file.log
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
