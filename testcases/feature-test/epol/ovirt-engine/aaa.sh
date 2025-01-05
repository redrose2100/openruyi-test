
#!/usr/bin/bash
# 本测试脚本用于测试 oVirt Engine Extension API 的 aaa 模块命令

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
    # 测试 aaa 模块的各个 action
    # 测试 authn-authenticate_credentials
    /usr/bin/ovirt-engine-extensions-tool aaa authn-authenticate_credentials --key=principal --output=stdout
    CHECK_RESULT $? 0 0 "authn-authenticate_credentials failed"

    # 测试 authz-fetch_principal_record
    /usr/bin/ovirt-engine-extensions-tool aaa authz-fetch_principal_record --key=principal --output=stdout
    CHECK_RESULT $? 0 0 "authz-fetch_principal_record failed"

    # 测试 change-credentials
    /usr/bin/ovirt-engine-extensions-tool aaa change-credentials --key=principal --output=stdout
    CHECK_RESULT $? 0 0 "change-credentials failed"

    # 测试 login-user
    /usr/bin/ovirt-engine-extensions-tool aaa login-user --key=principal --output=stdout
    CHECK_RESULT $? 0 0 "login-user failed"

    # 测试 search
    /usr/bin/ovirt-engine-extensions-tool aaa search --key=principal --output=stdout
    CHECK_RESULT $? 0 0 "search failed"

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
