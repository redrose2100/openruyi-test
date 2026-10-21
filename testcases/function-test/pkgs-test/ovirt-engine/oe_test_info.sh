
#!/usr/bin/bash
# 本测试脚本用于测试 oVirt Engine Extension API 的 info 模块及其相关参数和动作

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "ovirt-engine"
    # 准备测试数据等
    mkdir -p /etc/ovirt-engine/extensions.d/
    touch /etc/ovirt-engine/extensions.d/test-extension.py
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 info 模块的 context 动作
    /usr/bin/ovirt-engine-extensions-tool info context
    CHECK_RESULT $? 0 0 "info context action failed"

    # 测试 info 模块的 configuration 动作
    /usr/bin/ovirt-engine-extensions-tool info configuration
    CHECK_RESULT $? 0 0 "info configuration action failed"

    # 测试 info 模块的 list-extensions 动作
    /usr/bin/ovirt-engine-extensions-tool info list-extensions
    CHECK_RESULT $? 0 0 "info list-extensions action failed"

    # 测试 info 模块的 --output 参数
    /usr/bin/ovirt-engine-extensions-tool info context --output=stdout
    CHECK_RESULT $? 0 0 "info context action with --output=stdout failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "ovirt-engine"
    rm -rf /etc/ovirt-engine/extensions.d/
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
