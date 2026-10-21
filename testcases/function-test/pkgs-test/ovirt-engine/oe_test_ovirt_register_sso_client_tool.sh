
#!/usr/bin/bash
# 本测试脚本用于测试 oVirt SSO Client Registration Tool 的命令行参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "ovirt-engine"
    # 准备测试数据
    echo "Test CA Certificate" > ./test_ca_cert.pem
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试命令的基本用法
    /usr/bin/ovirt-register-sso-client-tool --help
    CHECK_RESULT $? 0 0 "Failed to run --help"
    
    # 测试 --callback-prefix-url 参数
    /usr/bin/ovirt-register-sso-client-tool --callback-prefix-url="https://example.com/callback"
    CHECK_RESULT $? 0 0 "Failed to run with --callback-prefix-url"
    
    # 测试 --client-ca-location 参数
    /usr/bin/ovirt-register-sso-client-tool --client-ca-location="./test_ca_cert.pem"
    CHECK_RESULT $? 0 0 "Failed to run with --client-ca-location"
    
    # 测试 --client-id 参数
    /usr/bin/ovirt-register-sso-client-tool --client-id="test-client-id"
    CHECK_RESULT $? 0 0 "Failed to run with --client-id"
    
    # 测试 --conf-file-name 参数
    /usr/bin/ovirt-register-sso-client-tool --conf-file-name="./test_conf_file.conf"
    CHECK_RESULT $? 0 0 "Failed to run with --conf-file-name"
    
    # 测试 --encoding-algorithm 参数
    /usr/bin/ovirt-register-sso-client-tool --encoding-algorithm="PBKDF2WithHmacSHA256"
    CHECK_RESULT $? 0 0 "Failed to run with --encoding-algorithm"
    
    # 测试 --encoding-iterations 参数
    /usr/bin/ovirt-register-sso-client-tool --encoding-iterations="5000"
    CHECK_RESULT $? 0 0 "Failed to run with --encoding-iterations"
    
    # 测试 --encoding-keysize 参数
    /usr/bin/ovirt-register-sso-client-tool --encoding-keysize="512"
    CHECK_RESULT $? 0 0 "Failed to run with --encoding-keysize"
    
    # 测试 --encrypted-userinfo 参数
    /usr/bin/ovirt-register-sso-client-tool --encrypted-userinfo="true"
    CHECK_RESULT $? 0 0 "Failed to run with --encrypted-userinfo"
    
    # 测试 --log-file 参数
    /usr/bin/ovirt-register-sso-client-tool --log-file="./test_log_file.log"
    CHECK_RESULT $? 0 0 "Failed to run with --log-file"
    
    # 测试 --log-level 参数
    /usr/bin/ovirt-register-sso-client-tool --log-level="DEBUG"
    CHECK_RESULT $? 0 0 "Failed to run with --log-level"
    
    # 测试 --version 参数
    /usr/bin/ovirt-register-sso-client-tool --version
    CHECK_RESULT $? 0 0 "Failed to run with --version"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "ovirt-engine"
    # 清理测试中间产物文件
    rm -f ./test_ca_cert.pem ./test_conf_file.conf ./test_log_file.log
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
